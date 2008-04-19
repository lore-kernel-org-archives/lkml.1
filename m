Return-Path: <linux-kernel-owner+w=401wt.eu-S1761756AbYDSXjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761756AbYDSXjd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 19:39:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751904AbYDSXjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 19:39:25 -0400
Received: from fmmailgate09.web.de ([217.72.192.184]:59133 "EHLO
	fmmailgate09.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbYDSXjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 19:39:24 -0400
Date: Sun, 20 Apr 2008 01:39:21 +0200
Message-Id: <246175158@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: linux-kernel@vger.kernel.org
Cc: djani22@netcenter.hu
Subject: Re:Sparse file question for data recovery
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX186uQseuhNu/fdND8OhAq9EgA+oOh+EzRv7XKTaM5NmnrJrN
 OocD5B7wlybqISEeMuhR8/Rk0zbj521xkqfaFC3daleabZdXkk=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

maybe cowloop  ? ( http://www.atcomputing.nl/Tools/cowloop/index.html )

there is also appropriate feature in mainline (device-mapper snapshots,  see Documentation/device-mapper/snapshot.txt ) 

maybe the thread at http://marc.info/?l=linux-kernel&m=114137441221113&w=2 is  worth taking a look.

roland


List:       linux-kernel
Subject:    Sparse file question for data recovery
From:       "Janos Haar" <djani22 () netcenter ! hu>
Date:       2008-04-19 22:15:15
Message-ID: 09eb01c8a26a$dbf5eee0$0404a8c0 () dcccs
[Download message RAW]

Hello list,

It is a way to use sparse files (or sg. else) to try to recover some big
block device when it is readonly?

I mean the original device is marked readonly, and only the changes are
saved for the sparse file.
This is useful if i want to only try to repair corrupted (or miss-assembled)
raid arrays, image from damaged hdd, etc...

Like only save the "undo" information independently from the repairing
program.

I only know that with nbd-server, but i wish to use a simple local solution.

Somebody have an idea? :-)

Thanks,

Janos Haar

_________________________________________________________________________
In 5 Schritten zur eigenen Homepage. Jetzt Domain sichern und gestalten! 
Nur 3,99 EUR/Monat! http://www.maildomain.web.de/?mc=021114

