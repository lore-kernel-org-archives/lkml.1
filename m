Return-Path: <linux-kernel-owner+w=401wt.eu-S1756649AbZGVJE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649AbZGVJE2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 05:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756643AbZGVJE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 05:04:26 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:32820 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756311AbZGVJEZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 05:04:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=tNMv7IOHwD+ZqlzONyrgcMs2eqn09NKz8xu9LCRXkJaGGNesBH6ZaGDNZsIuQd1B9b
         Y6jXBnDkYgUMv+8a9Bu/+N1eueC84hgIstyS2YdrW6935yJAN3iwdY8wv9xh/8oyjMM0
         CG8RDE406+WqE/h9u7l75OcTByigdspw6Iyq8=
MIME-Version: 1.0
Date: Wed, 22 Jul 2009 10:04:23 +0100
Message-ID: <66781b10907220204o26964a70j90348ec78a685b52@mail.gmail.com>
Subject: RAID60 - MD / LVM
From: mark delfman <markdelfman@googlemail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

Firstly let me apologise for what maybe a simple question, I have
tried to google and search this out.

The question is simply ‘the best way to create a RAID60 or any nested
RAID’.  Looking at the examples it seems the approach is to create 2 x
RAID6’s and then simply RAID0 on top.  However, is there any advantage
in using MD to create the RAID0 or would you see the same overall
result by using LVM to stripe (R0) the 2 x RAID6’s?

Given that I see a lot of post’s RE: RAID10, then I ‘suspect’ that the
MD RAID0 code has some understanding of or tuning for nested RAID’s,
which I guess LVM may not have.

It would seem the answer is obvious as it makes sense to simply use
MD, but we have an internal system based on 100’s of old scripts and
the RAID section only allows us to select  ‘drives’ (not raids), it
does however use LVM so it would be easier to change the script which
created the VG as opposed to change the many scripts related to RAID
creation...

If there is a real disadvantage in using LVM, then we can manually
create the RAID’s I guess....



I would appreciate any feedback
