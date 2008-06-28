Return-Path: <linux-kernel-owner+w=401wt.eu-S1758407AbYF1ROO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758407AbYF1ROO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 13:14:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753207AbYF1RN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 13:13:57 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:53557 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374AbYF1RN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 13:13:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=oR4FmKbpoK4CQc+UqD244rYU92VIOlP6Z+hKiYpMVua7Pn/XK/ZfqVEpf01dhLxCpN
         nAojszlihESz+0u3iS/s+/1qWLuXvIiTka/iIFMPIfSUTvZMCDp13txVBv0JKfQMhK6k
         UmfXKfHXqKxzZHAcFDyuq+r17gHSJydG6GxkQ=
Message-ID: <c384c5ea0806281013t50e56efes46ff7c53e58097ba@mail.gmail.com>
Date: Sat, 28 Jun 2008 19:13:55 +0200
From: "Leon Woestenberg" <leon.woestenberg@gmail.com>
To: trem <tremyfr@yahoo.fr>
Subject: Re: 2.6.24.7-rt14
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <g45dvm$pvt$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1214256117.8701.13.camel@localhost.localdomain>
	 <g45dvm$pvt$1@ger.gmane.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Jun 28, 2008 at 3:19 PM, trem <tremyfr@yahoo.fr> wrote:
> [trem@localhost rt-tests]$ sudo ./cyclictest -t 1 -p 80 -n -i 10000 -l

Just a warning to everyone, not that it affects the test or results in
case of 1 thread, but that should be -t1 instead of -t 1.

This little difference would matter if you decided to use more than 1 thread.

"-t NUM" will not pick up the NUM value, as optional arguments must
not have a space between the option and (optional) argument.

Regards,
-- 
Leon
