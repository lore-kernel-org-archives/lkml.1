Return-Path: <linux-kernel-owner+w=401wt.eu-S1754012AbYLBNgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbYLBNgr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 08:36:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754335AbYLBNgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 08:36:31 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:20596 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212AbYLBNg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 08:36:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=wNSgd3/gHLweMYt2tjXiZLdWlMnJl9KfnJ4zYpu6XRbBnmnFMsjLAcSkbA3ALugNJi
         JKnRIAGKzgu6jzoOr2dDngQP2GpgIxy5WGTtsy7H+s19r33fV26t7ai0MZqf5HIENSmm
         BbzHvPBHy1iBJ9Gs4Y4QdUc+K+QQ3kqg5Xogo=
Message-ID: <30353c3d0812020536t2074842lf4f1a1ef469f914f@mail.gmail.com>
Date: Tue, 2 Dec 2008 08:36:25 -0500
From: "David Ellingsworth" <david@identd.dyndns.org>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: Promise PDC20376
Cc: "Mikael Pettersson" <mikpe@it.uu.se>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081202105053.1bd78897@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <30353c3d0810240704n7476cc50y28b3eb8a5f326626@mail.gmail.com>
	 <30353c3d0811250616o733fb7f9ob4af96dd604f78ea@mail.gmail.com>
	 <18732.3809.720247.329641@harpo.it.uu.se>
	 <30353c3d0812011743we0bdddk2c9c37dd0191cf2a@mail.gmail.com>
	 <20081202105053.1bd78897@lxorguk.ukuu.org.uk>
X-Google-Sender-Auth: 06638c4d47060982
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 2, 2008 at 5:50 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> A small update to this. It seems the above mentioned interrupt fails
>> somewhere around the 128GB boundary. Interrupt 13h, AH=42 uses a 64
>> bit sector address and should be capable of addressing the entire
>> drive. For a SATA controller, this limitation seems relatively
>> arbitrary. For IDE controllers, a limitation such as this is
>> apparently common.
>
> 137GB I would imagine. That is the point at which LBA48 commands must be
> used not LBA28 and presumably their BIOS code only supports old format
> commands
>

Right, with LBA28 addressing you get 2^28 sector addresses = 2^27 KiB
= 2^17 MiB = 2^7 GiB = 128 GiB which is approximately 137GB. When I
wrote 128GB I really meant 128 GiB.

Regards,

David Ellingsworth

P.S. I hate the "new" binary size notations they only cause confusion.
