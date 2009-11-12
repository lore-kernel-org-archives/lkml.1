Return-Path: <linux-kernel-owner+w=401wt.eu-S1759790AbZKLA2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759790AbZKLA2T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 19:28:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759685AbZKLA2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 19:28:18 -0500
Received: from mail-iw0-f178.google.com ([209.85.223.178]:43907 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759619AbZKLA2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 19:28:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=WC5P3Fo/JuvgtIWuqXk7agFV18rvsDf/PQpuOThnYVB7lMISibYsmGr/Ph6JmZewkG
         yRi2xpjIMNMoD5VvOLBpBml2CbPFQX8SpnYSz9XfwO8jhrkYqkFQ0gR4P7Lhtn/gBaOB
         ljYnglpml5c9Gft0pd0D3cq6hm3jV1gOB/eVA=
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.0910200047200.8582@wotan.suse.de>
References: <1255906474-25091-1-git-send-email-felipe.contreras@gmail.com>
	 <1255906474-25091-3-git-send-email-felipe.contreras@gmail.com>
	 <alpine.LSU.2.00.0910191610160.8582@wotan.suse.de>
	 <94a0d4530910190750j5674ef13m93198b68d305b188@mail.gmail.com>
	 <alpine.LSU.2.00.0910191655220.8582@wotan.suse.de>
	 <94a0d4530910190815n4cf2c2ebmd288f6e7501b1ba5@mail.gmail.com>
	 <alpine.LSU.2.00.0910191716580.8582@wotan.suse.de>
	 <94a0d4530910190949y265426cbq4c32466a9fab8966@mail.gmail.com>
	 <alpine.LSU.2.00.0910200047200.8582@wotan.suse.de>
Date: Thu, 12 Nov 2009 02:28:23 +0200
Message-ID: <94a0d4530911111628p3edad1a0me3bb9f312491c637@mail.gmail.com>
Subject: Re: [PATCH 2/7] ipc: fix trivial warning
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 20, 2009 at 12:50 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Mon, 19 Oct 2009, Felipe Contreras wrote:
>> Yes, but it's used by ipcctl_pre_down, which from what I can see is
>> only using those arguments when cmd == IPC_SET, so everything is ok.
>> But still, I don't think the compiler _should_ know what
>> ipcctl_pre_down is going to do, if you look _only_ at msgctl_down,
>> then uninitialized_var is OK.
>
> Well at least older compilers were able to see this, only 4.4 seems to be
> warning here ... I have applied the patch for now, but I am really not
> fully convinced about it yet, we should probably report it to gcc folks
> anyway.

I have in my to-do list to report this to the gcc guys, but in the
meantime I don't see this patch applied.

-- 
Felipe Contreras
