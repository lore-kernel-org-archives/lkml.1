Return-Path: <linux-kernel-owner+w=401wt.eu-S1753947Ab0AYPZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab0AYPZF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 10:25:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753694Ab0AYPZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 10:25:04 -0500
Received: from mail-iw0-f186.google.com ([209.85.223.186]:52159 "EHLO
	mail-iw0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849Ab0AYPZD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 10:25:03 -0500
MIME-Version: 1.0
In-Reply-To: <4B5C963D.8040802@rozsnyo.com>
References: <4B5C963D.8040802@rozsnyo.com>
Date: Mon, 25 Jan 2010 17:25:02 +0200
X-Google-Sender-Auth: 4d87df8054ae36da
Message-ID: <5ec358371001250725l40b13060md880001c96be165f@mail.gmail.com>
Subject: Re: bio too big - in nested raid setup
From: Marti Raudsepp <marti@juffo.org>
To: =?ISO-8859-1?Q?Ing=2E_Daniel_Rozsny=F3?= <daniel@rozsnyo.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/1/24 "Ing. Daniel Rozsnyó" <daniel@rozsnyo.com>:
> Hello,
>  I am having troubles with nested RAID - when one array is added to the
> other, the "bio too big device md0" messages are appearing:
>
> bio too big device md0 (144 > 8)
> bio too big device md0 (248 > 8)
> bio too big device md0 (32 > 8)

I *think* this is the same bug that I hit years ago when mixing
different disks and 'pvmove'

It's a design flaw in the DM/MD frameworks; see comment #3 from Milan Broz:
http://bugzilla.kernel.org/show_bug.cgi?id=9401#c3

Regards,
Marti
