Return-Path: <linux-kernel-owner+w=401wt.eu-S1760061AbZFJATO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760061AbZFJATO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 20:19:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754683AbZFJAS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 20:18:59 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:51760 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383AbZFJAS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 20:18:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QOuQKqMb3zzyNTJj7rBI8HGWkw6XAsf3bohYsvp3uiCC2Cjn3BvQzDBwJBG0ES1TlO
         aiXfjbvyg0Jb59qF/k5D2frHJmuQJYteJ/yOXP4j27J8/iFLl6Ml50HOs+cPZiWCota+
         fkYJlB5nEyYNqhzqUZ+MliViKC6M1KGBAiFnc=
MIME-Version: 1.0
In-Reply-To: <20090609164529.GA11592@srcf.ucam.org>
References: <20090331221107.GA30383@srcf.ucam.org>
	 <20090331230217.GA31599@srcf.ucam.org>
	 <74962ea30904010950u31fbdca3w51eafb9b7ec1ca73@mail.gmail.com>
	 <20090401165345.GA13939@srcf.ucam.org>
	 <74962ea30904011003o354e8780ya5e9ac1a6a579084@mail.gmail.com>
	 <20090401170708.GA14167@srcf.ucam.org>
	 <74962ea30904011013v5ffa0620y1f1aefa2c84e1ce@mail.gmail.com>
	 <20090602140357.GA13548@srcf.ucam.org>
	 <74962ea30906090942r43d374e7ra00e5056eca040a8@mail.gmail.com>
	 <20090609164529.GA11592@srcf.ucam.org>
Date: Tue, 9 Jun 2009 18:18:59 -0600
Message-ID: <74962ea30906091718o274a0968ica61ee7a8d915ed5@mail.gmail.com>
Subject: Re: [PATCH 2/2] toshiba-acpi: Support TOS1900-type devices
From: Azael Avalos <coproscefalo@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-acpi@vger.kernel.org, dsilvers@simtec.co.uk,
       toshiba_acpi@memebeam.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 9, 2009 at 10:45 AM, Matthew Garrett<mjg59@srcf.ucam.org> wrote:

> When you hit a hotkey, what happens in /proc/interrupts? Do you see an
> i8042 event or an acpi event?

Indeed an i8042 event pops up, actually dmesg shows the following
regardless of the hotkey pressed, even by only pressing the Fn key:

atkbd.c: Unknown key released (translated set 2, code 0x6e on isa0060/serio0).
atkbd.c: Use 'setkeycodes 6e <keycode>' to make it known.


Saludos
Azael


-- 
-- El mundo apesta y vosotros apestais tambien --
