Return-Path: <linux-kernel-owner+w=401wt.eu-S932484AbZJ1BSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932484AbZJ1BSi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 21:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757112AbZJ1BSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 21:18:37 -0400
Received: from mail-yw0-f202.google.com ([209.85.211.202]:34613 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757107AbZJ1BSh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 21:18:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tHK4gAXYm0dFyaZSRTiv4p2l5ICSPJkkUa3vEUuraVq+rHz4xcJDW0TxNIJNU5aCbD
         pmpTe4APCpXc2RWwx4gWCbHGUks9JhMBiD1gXm7PigJW5KnsTqQfsQrTClRtj0Y/g7PR
         Z08gYXCM39ZHyHcGBvTrNLn7I4Cwq7ZfrzSX8=
MIME-Version: 1.0
In-Reply-To: <20091027211951.GA21967@elf.ucw.cz>
References: <20091027211951.GA21967@elf.ucw.cz>
Date: Wed, 28 Oct 2009 09:18:41 +0800
Message-ID: <2674af740910271818s62307532l9e74b37f439f6206@mail.gmail.com>
Subject: Re: 2.6.32-rc5: surprise removal of USB mass storage, and whole 
	system goes to hell
From: Yong Zhang <yong.zhang0@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 28, 2009 at 5:19 AM, Pavel Machek <pavel@ucw.cz> wrote:
>
> I did remove one harddrive w/o unmounting, and now the whole system
> becomes unusable :-(: (whole dmesg attached).
>
> Stuff like "sync" hangs, and I'll probably have to reboot soon.
>                                                                Pavel

This a known bug(Bug #14481).

Cc'ed Rafael
