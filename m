Return-Path: <linux-kernel-owner+w=401wt.eu-S1760120AbYEXATW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760120AbYEXATW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 20:19:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753238AbYEXATP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 20:19:15 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:3172 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914AbYEXATO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 20:19:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PdChcavu9xAaIOokJTRYqW+wRhldl7JG0DGV5th17gP3j8haD0VZ8w0OZNbD6hkftj4quuH5nUY+s/gg/plqmE74T4C2ygBt9WloQ47kHSrVOY+bwXWcf7PxOWrTcTktG+pmqr37vZ5Hb9L/mxjPk76/VsJUTa1b92ZdJjKFLL8=
Message-ID: <d8d698ae0805231719g4202edf2k947bba4128385ab6@mail.gmail.com>
Date: Fri, 23 May 2008 21:19:13 -0300
From: "Fausto Richetti Blanco" <fausto.blanco@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Pipe buffers' limit of 16 * 4K
In-Reply-To: <d8d698ae0805231255i4d0da724p68cb2b9376134797@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d8d698ae0805231255i4d0da724p68cb2b9376134797@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello guys,

       I'm working with a 2.6.9 kernel (ok, I know it's quite old) and
faced a problem with the 4K (one page) buffer limit for the pipes.
I've found that in the 2.6.11 the pipes' buffers were changed to a
circular list of pages which increased this limit to 16 * 4K. This
limit is hardcoded here /usr/src/linux/include/linux/pipe_fs_i.h:6
#define PIPE_BUFFERS (16)

       Is there a reason for this not to be an adjustable parameter
(eg.: by an ulimit in the userspace) ?

       Can you please CC me on the answer ?

       Thanks in advance,

            Fausto Richetti Blanco
