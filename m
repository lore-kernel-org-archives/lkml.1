Return-Path: <linux-kernel-owner+w=401wt.eu-S934082AbXCFMFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934082AbXCFMFu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 07:05:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934085AbXCFMFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 07:05:50 -0500
Received: from qb-out-0506.google.com ([72.14.204.227]:39404 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934082AbXCFMFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 07:05:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=rLGFh6JJi80kcn1/+q6/AZyFg3S1gHeDXy2FDQg6rVNSypIhiJjbLE5qK3Kjnlb8CZCEOqU1TLcNdgcqHLvtwaVlHySJ+IfWbeJQrQBd912S33YQ4Al3bmOGJ05K8OZJJronIni3KNQtnEgJyYhMyZWP0Zwytv6BLmOwonohCLA=
Message-ID: <2cf1ee820703060405l1cd30bf1o896910341bb8f293@mail.gmail.com>
Date: Tue, 6 Mar 2007 14:05:42 +0200
From: "emin ak" <eminak71@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: encrypting jffs2 filesystem with DM-crypt or what else?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Folks,
I need to encrypt a jffs2/mtd formatted flash filesystem for an
embedded device, Normally using a loopback interface (cryptoloop,
DM-crypt or loop-aes) solves this problem but they are not well known
on journalling file systems (like jffs2) because of cached write etc..
Also I could'nt find any guideline for encrypting fikesystem on a
flash.
There is an ugly workaround to overcome this problem, I have placed an
encrypted ext2 filesystem image on an normal jffs2 partition and mount
this encrypted partition on a loopback, but this is not secure,
consumes alot for disk space and not reliable (is'nt it?)
Is there any other way to encrypt an jjffs2 partition, if not, what do
you think about my ugly workaround?
Thank alot
Emin
