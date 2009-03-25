Return-Path: <linux-kernel-owner+w=401wt.eu-S1762861AbZCYP2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762861AbZCYP2A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 11:28:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762601AbZCYP12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 11:27:28 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:35117 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762677AbZCYP11 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 11:27:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=lEUg4VkN8mZNgMRBjCyNd1IcwhPA7RBU/8vudw5Utyw2t2fKqBIRj674lia64/393R
         EoKoMzZtGEGiPbxde0pWoa+9EGsFyBrzM8Cs9/T5dlXCGyIyHDg2jmjPiD0j7qumZ2XC
         ut0Lmfb05c2yjS1GNxXLpfsVuKeQNqDYSm2Kc=
MIME-Version: 1.0
Reply-To: petkovbb@gmail.com
In-Reply-To: <9ea470500903250812r19970910h12d197716d262c82@mail.gmail.com>
References: <1237990673-8358-1-git-send-email-tj@kernel.org>
	 <1237990673-8358-5-git-send-email-tj@kernel.org>
	 <9ea470500903250812r19970910h12d197716d262c82@mail.gmail.com>
Date: Wed, 25 Mar 2009 16:20:50 +0100
Message-ID: <9ea470500903250820x2dfbf1f0q6e7d16191923cb3c@mail.gmail.com>
Subject: Re: [PATCH 04/10] ide-tape: use standard data transfer mechanism
From: Borislav Petkov <petkovbb@googlemail.com>
To: Tejun Heo <tj@kernel.org>
Cc: bzolnier@gmail.com, linux-kernel@vger.kernel.org, axboe@kernel.dk,
       linux-ide@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>        drive->pc_callback       = ide_tape_callback;
>> -       drive->pc_update_buffers = idetape_update_buffers;
>> -       drive->pc_io_buffers     = ide_tape_io_buffers;
>
> You might just as well remove those two ide_drive_t members since
> they're used only by ide-tape.

Ah, nevermind. You've done it later in patch 9/10.

-- 
Regards/Gruss,
Boris
