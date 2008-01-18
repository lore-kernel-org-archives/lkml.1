Return-Path: <linux-kernel-owner+w=401wt.eu-S1758183AbYARDLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183AbYARDLT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 22:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751102AbYARDLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 22:11:07 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:22247 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbYARDLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 22:11:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=wzC6Mfy4CCkm0Kv+KnZZPeX1W/BVyK6zIKg9WoIwSIv8LCSfiAVXGkW2x58j9bHznq6ThKjmGVqkLK6YqRoLKLu2s/4QrvgWUhaN7OPY/E6kITFVq5MZ7NsADmDzUaw8nrIYSfP3uZMQRGRyBIQgS6HSKxjxO+zphzA/XAoFI+g=
Message-ID: <86802c440801171911p3d82c39ap29da2d81c63c77c2@mail.gmail.com>
Date: Thu, 17 Jan 2008 19:11:03 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: x86.git kexec rhel 5.1
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

some problem with PAT

A: 1/17 x86.git with PAT enable kernel
B. 1/17 x86.git with PAT diabled kernel
C: RHEL 5.1 stock kernel -53

A kexec B : OK
B kexec A:  OK
A kexec C: very slow
B kexec C:  OK
C kexec A:  OK
C kexec B:  OK

Do we need something to disable PAT when kexec calling shutdown?

YH
