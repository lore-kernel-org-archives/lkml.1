Return-Path: <linux-kernel-owner+w=401wt.eu-S1751639AbYHSNis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751639AbYHSNis (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 09:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706AbYHSNij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 09:38:39 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:50035 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbYHSNii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 09:38:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=s4lcdDfE5lMb422M7Ios37f52NbJFjqbjPbNen2/Gdf/pqMxgrn5ZaCv2FZ/02fU30
         8FzLm7iz3hiBdFYof4GyvB+o9ocHjy6cRuMZfIlte9t+UioYQ3QV5HgYU/uUBE9A5Zk0
         VfDLeKeH9LdzGWZ3qXRF4LoYwsFVqbsqx/GTo=
Message-ID: <ac9c93b10808190638q16fb54d6uef68548b7e5fd526@mail.gmail.com>
Date: Tue, 19 Aug 2008 15:38:37 +0200
From: "Frans Meulenbroeks" <fransmeulenbroeks@gmail.com>
To: linux-kernel@vger.kernel.org, jdike@karaya.com, viro@zeniv.linux.org.uk
Subject: hppfs; CONFIG_HPPFS; used ?? or orphaned??
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While roaming through the fs tree I bumped upon the directory hppfs (not hpfs!)

Is this one orphaned?
I saw that the Makefile references CONFIG_HPPFS, but I could not find
it in a Kconfig file nor in the .config I generated (not even a
CONFIG_HPPFS not set line).
(so either it does not exist, or my eyes are getting old).

As such it does not seem too useful (unless I am overlooking things):

Two options:
- add it to some Kconfig (and note I cannot do that, I have not the
faintest idea what it is, actually I got there out of curiosity).
- rm -rf hppfs
