Return-Path: <linux-kernel-owner+w=401wt.eu-S1758768AbXLPTvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758768AbXLPTvu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 14:51:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755292AbXLPTvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 14:51:42 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:24406 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754969AbXLPTvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 14:51:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=jag+1F2DGRXZHSvmpvUJAPIhP4+Lxvd0Go69iC5uV6ClScwJKl3W4LJIoGPoHJzWH+nYJl4HTzmLf2aITlxXtHORb/gDxFLGdo1wLA9wTMG4gBxGZqgwEo1CvHnapr9M7mVgK1zPkePe0+2Zac1DZOvwDm8j9ub9OgNcqag2E/I=
Message-ID: <ee3dc96c0712161151x7941e4e1y51a7631ada375c70@mail.gmail.com>
Date: Sun, 16 Dec 2007 16:51:39 -0300
From: "Rafael Sisto" <rafael.sisto@gmail.com>
To: "Linux kernel" <linux-kernel@vger.kernel.org>
Subject: shared memory
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Im working on a project working on linux kernel 2.6.17
I have to share memory on user level... I have to build something like
a server process that "exports" a portion of his virtual memory, and
other client process may ask the kernel for that memory and use it (as
its own).
I managed to build a structure on the kernel. The server process calls
a system-call and tells the kernel which pointer and size to share. Im
saving that data (virtual memory pointer and size) and the pid in the
structure.

After that, the client process calls another system call to get the
shared memory. My idea is to create a new vma_struct in the client
process pointing to the server shared memory.. The problem is I can't
see how to make a vma_struct to point directly to the server's
memory...

Can anybody help me with this issue? Any comment or suggestion would
be gratefuly accepted!

greetings from Uruguay!
Rafael Sisto
