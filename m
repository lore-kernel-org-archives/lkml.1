Return-Path: <linux-kernel-owner+w=401wt.eu-S1753306AbZLOPTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbZLOPTx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 10:19:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752497AbZLOPTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 10:19:52 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:33037 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297AbZLOPTv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 10:19:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pjOZ/vZ/7jHkYo6f4XFGMF1SB9aeGjcWMICCZP5uIbGKiu73zEWaqQ4T36b8ZAbAfl
         uTzuoXjWU12TxBq/cl16r8Pzra/8Cvas4VFdvRrhdq9IAWZ6gSt8RHu/QKHDdUGAN2B3
         Sr60tg6h6LxDBjjveeZI6aPAdbTC1sWV7FQdY=
MIME-Version: 1.0
In-Reply-To: <20091215145737.GA8209@ldl.fc.hp.com>
References: <20091214023051.GA29591@ldl.fc.hp.com>
	 <1260759123.3391.0.camel@localhost>
	 <20091214031127.GB29591@ldl.fc.hp.com>
	 <7b6bb4a50912132128r68dbd8b3p9304920e3080b5e1@mail.gmail.com>
	 <20091215054004.GF587@ldl.fc.hp.com>
	 <a728f9f90912150652p7fc1c2d8tc341e4c6f59e5346@mail.gmail.com>
	 <20091215145737.GA8209@ldl.fc.hp.com>
Date: Tue, 15 Dec 2009 10:19:49 -0500
Message-ID: <a728f9f90912150719x7db56ee7p589c0f4fc2594b2d@mail.gmail.com>
Subject: Re: radeon 4830 corruption after resume
From: Alex Deucher <alexdeucher@gmail.com>
To: Alex Chiang <achiang@hp.com>
Cc: Xiaotian Feng <xtfeng@gmail.com>, rjw@sisk.pl,
       Dave Airlie <airlied@redhat.com>, dri-devel@lists.sourceforge.net,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 9:57 AM, Alex Chiang <achiang@hp.com> wrote:
> * Alex Deucher <alexdeucher@gmail.com>:
>>
>> As Dave asked previously, is this a regression?  I.e., did s/r work at
>> some point in the past and if so when?
>
> I'm not sure, as I just received the machine a few days ago.
>
> I can try some older kernels, but part of my issue is not knowing
> how all the pieces fit together. How can I tell if I'm supposed
> to be bisecting the kernel or X or something else, given my
> symptoms?

First try s/r without X running and see if it works ok.  Then try s/r
from a VT other than the one X is on. Finally, try s/r with the DRI
disabled (i.e., Option "DRI" "False" in the device section of your
config).  Also for non-kms s/r, you may have to fiddle with vbetool on
resume to post your card.  Report back with the results and we can go
from there.

Alex
