Return-Path: <linux-kernel-owner+w=401wt.eu-S1751948AbZKATUF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948AbZKATUF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 14:20:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751499AbZKATUD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 14:20:03 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:42381 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbZKATUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 14:20:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=OutzwgF0zJx3grnTMDk8ktXTllCyoV37Wq/2KK1Q9OjdPdZBdrp7xR0l3mO9RVilAy
         1SSjRcAkPXgG0+sjbuPRn7uOIjSJtXIjDjzrm06x8ZkEntOmYc66orob/JjWIr1Uv5PU
         gQW4qaXre0R7FNPWjLYM+xvKhkIcej6zYZql8=
Subject: Re: FatELF patches...
From: David Hagood <david.hagood@gmail.com>
To: "Ryan C. Gordon" <icculus@icculus.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.0910271410510.16178@andre.icculuslan>
References: <alpine.DEB.2.00.0910271410510.16178@andre.icculuslan>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 01 Nov 2009 13:20:01 -0600
Message-ID: <1257103201.2865.6.camel@chumley>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-29 at 22:19 -0400, Ryan C. Gordon wrote:
> Having heard a bunch of commentary, and made a bunch of changes based on 
> some really good feedback, here are my hopefully-final FatELF patches.

I hope it's not too late for a request for consideration: if we start
having fat binaries, could one of the "binaries" be one of the "not
quite compiled code" formats like Architecture Neutral Distribution
Format (ANDF), such that, given a fat binary which does NOT support a
given CPU, you could at least in theory process the ANDF section to
create the needed target binary? Bonus points for being able to then
append the newly created section to the file.

That way you could have a binary that supported some "common" subset of
CPUs (e.g. x86,x86-64,PPC,ARM) but still run on the "not common"
processors (Alpha, MIPS, Sparc) - it would just take a bit more time to
start.

As an embedded systems guy who is looking to have to support multiple
CPU types, this is really very interesting to me.


