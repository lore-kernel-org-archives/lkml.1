Return-Path: <linux-kernel-owner+w=401wt.eu-S1754619AbZDPUkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619AbZDPUkA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 16:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752901AbZDPUjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 16:39:47 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:16116 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878AbZDPUjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 16:39:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=mKaOtdK7iCTeWNe8oob5wW3qrTEs+f86Z/muwwbSOPeboajDVIIPHRKoCzY2bXCdHQ
         kDZbH45UbnlXOOj5sngpYJgByz/B1hPe1MaICxV19H3kkwhAEf3vC+l3v600zPHqDOcT
         +CYveO7jUBlTSO784qstSV7LpvVva4jPhtfIc=
MIME-Version: 1.0
Date: Thu, 16 Apr 2009 16:39:45 -0400
Message-ID: <cf4f48500904161339n627e2127k7e9b4abeb0621c28@mail.gmail.com>
Subject: Basic rundown of udev?
From: John Moser <john.r.moser@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm currently reading through umm... udevd.c for udev-141.  Trying to
figure out how this thing works.

Anyone care to give me a brief map?  It would help.  I'm just trying
to figure out how udev talks to the kernel-- i.e. what facilities
would I have to implement to re-implement the kernel side of udev,
let's say if I was to run udevd as-is on Darwin or NetBSD or
something.  How does it talk to the kernel?  And if you know off the
top of your head, which source files (and functions?) am I looking at
here?
