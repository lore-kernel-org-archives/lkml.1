Return-Path: <linux-kernel-owner+w=401wt.eu-S1758635AbYEMGbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758635AbYEMGbN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 02:31:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756350AbYEMGa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 02:30:59 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:11961 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755783AbYEMGa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 02:30:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=u47AKmNc0g4KNMeVdPGa1bXcfwFl/RGBkDkNYqH2JylpgOZS9s5Ivawe2KgLwDMsmRzRZZ1ujOHI7gh5Xq3xo2sbwWJej59ZiLmtW/f0x6DGE8kITiluFM7eIvbWZONxma6hxEnZjYrg1NroMtosqKTODPyV7xvMK+OJ2eudTpY=
Message-ID: <f36b08ee0805122330p6b479bc9s1db48c8c466d0ae9@mail.gmail.com>
Date: Tue, 13 May 2008 08:30:48 +0200
From: "Yakov Lerner" <iler.ml@gmail.com>
To: "Kernel Linux" <linux-kernel@vger.kernel.org>
Subject: calculate actual state of caches wrt set of files/dirs, without modifying caches ?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is it possible to calculate the following thing from userspace:
Some benchmarking program has list of filenames and dirnames.
Can it calculate how many of inodes and data blocks of those items are *cached*
vs how many are not, without modifying existing
status of inode caches & buffer caches ?

Thanks
Yakov
