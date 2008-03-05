Return-Path: <linux-kernel-owner+w=401wt.eu-S1762823AbYCEVoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762823AbYCEVoM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 16:44:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763143AbYCEVnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 16:43:32 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:22678 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763146AbYCEVna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 16:43:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:message-id:from:to:in-reply-to:content-type:x-mailer:mime-version:subject:content-transfer-encoding:date:cc;
        b=KNLTJrCfecZPs9NV2qyNk7rwlC1DQbu88mFZX8Jw+hmG1SlKY70s7fGE2hGfXW3ug0wItw2RUwA+f5xsWPelsCkpm2+g3WlraDlMK8mzq6ko25kE16qL9G9w6T2Ltpg8Xk2/oUXqbLl7Ev4pE5yXxJfws9gBG+4UgYRCsNOQTxw=
References: <20080305153020.GA24631@volta.aurel32.net> <47CEC3AA.6080709@zytor.com> <20080305195834.GA17267@synopsys.com> <20080305202319.GA17053@volta.aurel32.net> <Pine.LNX.4.64.0803052133400.20583@wotan.suse.de> <20080305204234.GB17267@synopsys.com> <20080305204945.GB14011@atrey.karlin.mff.cuni.cz> <Pine.LNX.4.64.0803052158270.20583@wotan.suse.de> <20080305212005.GC17267@synopsys.com>
Message-Id: <D9F7D02C-D312-48F3-A437-0C41ADCC4F5F@gmail.com>
From: Andrew Pinski <pinskia@gmail.com>
To: Joe Buck <Joe.Buck@synopsys.COM>
In-Reply-To: <20080305212005.GC17267@synopsys.com>
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed;
	delsp=yes
X-Mailer: iPhone Mail (4A102)
Mime-Version: 1.0 (iPhone Mail 4A102)
Subject: Re: RELEASE BLOCKER: Linux doesn't follow x86/x86-64 ABI wrt direction flag
Content-Transfer-Encoding: 7bit
Date: Wed, 5 Mar 2008 13:43:08 -0800
Cc: Michael Matz <matz@suse.de>, Jan Hubicka <hubicka@ucw.cz>,
       Aurelien Jarno <aurelien@aurel32.net>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are already gcc 4.3.0 packages on the FTP site.

Sent from my iPhone

On Mar 5, 2008, at 13:20, Joe Buck <Joe.Buck@synopsys.COM> wrote:

>
>
> On Wed, 5 Mar 2008, Jan Hubicka wrote:
>>> Linux kernel is disabling red zone and use kernel code model, yet  
>>> the
>>> ABI is not going to be adjusted for that.
>>>
>>> This is resonably easy to fix on kernel side in signal handling,  
>>> or by
>>> removing std usage completely
>
> On Wed, Mar 05, 2008 at 10:02:07PM +0100, Michael Matz wrote:
>> That is true.  But it requires updating the kernel to a fixed one  
>> if you
>> want to run your programs compiled by 4.3 :-/  Not something we'd  
>> like to
>> demand.
>
> I changed the title just for emphasis.
>
> I think that we can't ship 4.3.0 if signal handlers on x86/x86_64
> platforms for both Linux and BSD systems will mysteriously (to the  
> users)
> fail, and it doesn't matter whose fault it is.
>
>
