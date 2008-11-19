Return-Path: <linux-kernel-owner+w=401wt.eu-S1753298AbYKSJ7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298AbYKSJ7w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 04:59:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583AbYKSJ7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 04:59:44 -0500
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2102 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbYKSJ7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 04:59:43 -0500
Date: Wed, 19 Nov 2008 10:59:41 +0100
From: Folkert van Heusden <folkert@vanheusden.com>
To: linux-kernel@vger.kernel.org
Subject: kobject: 'vcs1' (d2172ad8): kobject_add_internal: parent: 'vc',
	set: 'devices'
Message-ID: <20081119095934.GF4370@vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Sat Nov 15 16:05:58 CET 2008
X-Message-Flag: www.unixexpert.nl
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

What switch is responsible for this logging:
[   94.025172] kobject: 'vcsa1': free name
[   94.025231] kobject: 'vcs1' (d2172ad8): kobject_add_internal: parent: 'vc', set: 'devices'
[   94.025308] kobject: 'vcs1' (d2172ad8): kobject_uevent_env
[   94.025315] kobject: 'vcs1' (d2172ad8): fill_kobj_path: path = '/class/vc/vcs1'
[   94.025352] kobject: 'vcsa1' (d23f00d8): kobject_add_internal: parent: 'vc', set: 'devices'
[   94.025398] kobject: 'vcsa1' (d23f00d8): kobject_uevent_env

I can't find it and it removes an oops from dmesg before i can capture it.


Folkert van Heusden

-- 
MultiTail är en flexibel redskap för att fälja logfilar, utför av
commandoer, filtrera, ge färg, sammanfoga, o.s.v. följa.
http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
