Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427Ab0CKVJu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 16:09:50 -0500
Received: from mail-fx0-f227.google.com ([209.85.220.227]:62291 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325Ab0CKVJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 16:09:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:from:date:x-google-sender-auth:message-id
         :subject:to:content-type;
        b=PD6KlKKG2y8od/V/6g2vo5tzQct2FIxTJYLoC9TM6KkmcKwEFgvQME9LzjYP6QhB/X
         t254pogQ3QhGKqxwDwa808Mddsx3Mh2w5dyUoiL+Awd+UHS+dnh0Q7ZDJtC0MzvIqMzQ
         n58Z2L6DJ9Y4H2sfJVdPUxayJPgZIpItlXo98=
MIME-Version: 1.0
From: Andrew Lutomirski <luto@mit.edu>
Date: Thu, 11 Mar 2010 16:09:26 -0500
X-Google-Sender-Auth: 89b09c11207bd9f3
Message-ID: <cb0375e11003111309m21010d0an2f0e0dbf5196a95c@mail.gmail.com>
Subject: Missing btrfs.8.in in latest git
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new btrfs util was just added on the subvol branch of
btrfs-progs-unstable, and man/Makefile wants to build btrfs.8.gz, but
the source is missing.  Presumably it should either be added or the
makefile adjusted.
