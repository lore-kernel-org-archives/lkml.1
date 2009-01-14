Return-Path: <linux-kernel-owner+w=401wt.eu-S1759655AbZANHig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759655AbZANHig (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 02:38:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754329AbZANHi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 02:38:27 -0500
Received: from mail-gx0-f26.google.com ([209.85.217.26]:50697 "EHLO
	mail-gx0-f26.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638AbZANHi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 02:38:26 -0500
X-Greylist: delayed 1006 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Jan 2009 02:38:26 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=TS2PYWh2uygY5Ad2b0dxaUZiVDjEgH5vVaOkybmPFT2mpH4S+0d4MNaz35Z/rXJ21v
         14TGj94pCpDP2ud2J2vd+gMwxtWHYuCXkiPkqt5r7HtkendpWrDsfRr/Eh5y8eSxZA9b
         AI4pf9Z6n50cMrzNOUUru/96u3O2g4S2Say8c=
Message-ID: <2fa748260901132321k6f24f567u65691f653e2ec62b@mail.gmail.com>
Date: Tue, 13 Jan 2009 23:21:39 -0800
From: anarcherty <anarcherty@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: lock_page_killable limitations?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What's preventing lock_page_killable from replacing lock_page?

Is there more on the table than implementing the small amount of at
each callsite of lock_page to handle the return condition -- ie,
restrictions that prevent the kernel from being able to fail at
successfully requiring and releasing a lock?
