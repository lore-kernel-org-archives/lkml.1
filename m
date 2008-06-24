Return-Path: <linux-kernel-owner+w=401wt.eu-S1761278AbYFXOdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761278AbYFXOdv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 10:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754911AbYFXOdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 10:33:41 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:39482 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935AbYFXOdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 10:33:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=J/qKMG29Vw+c9E+cl7pp30j4YwGs5OKHkZwDDr/tSDzY3tg84qDWRff0bh3favDlBA
         7sEABNlCrz0oDgJkl6AOPVEVcgHUsa6SO9knoer34/Yt9fhPKDhlksJoKIAIa+0y3hKo
         ksc0NSBqAvtIZ1g7vqkFapKg8IzkMZay6NbNM=
Message-ID: <58cb370e0806240733q5a6987f4q7f103e3864b09e62@mail.gmail.com>
Date: Tue, 24 Jun 2008 16:33:38 +0200
From: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] IDE: Fix HDIO_DRIVE_RESET handling
Cc: "Elias Oltmanns" <eo@nebensachen.de>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Randy Dunlap" <randy.dunlap@oracle.com>
In-Reply-To: <58cb370e0806240719o4a70537p4a6fb64e9086e2d8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <87k5gmz596.fsf@denkblock.local>
	 <200806240041.42796.bzolnier@gmail.com>
	 <87skv3s3d9.fsf@denkblock.local>
	 <200806241306.42054.bzolnier@gmail.com>
	 <20080624133218.6bccab75@lxorguk.ukuu.org.uk>
	 <58cb370e0806240621g61370f56j660e31790dad89c3@mail.gmail.com>
	 <20080624143548.24dcf511@lxorguk.ukuu.org.uk>
	 <58cb370e0806240719o4a70537p4a6fb64e9086e2d8@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2008 at 4:19 PM, Bartlomiej Zolnierkiewicz
<bzolnier@gmail.com> wrote:

[...]

> IOW while the two operations are very similar on the drive level they
> certainly have different needs and requirements at the higher level
> (abort operation being especially tricky).

The confusion seems to be caused by unfortunate use of the word
'hardware' in my initial mail ('system' should be more proper)...
