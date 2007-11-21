Return-Path: <linux-kernel-owner+w=401wt.eu-S1759800AbXKUMYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759800AbXKUMYN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 07:24:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753633AbXKUMX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 07:23:59 -0500
Received: from wr-out-0506.google.com ([64.233.184.227]:9675 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505AbXKUMX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 07:23:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=G6ftaEPe75zuM21hg6ywzI/mOYEVOsPIYiWHhFAg+VYPSDpUjEYWb1ZF6w6J4VSg5+iF6mvVWDAnN2QbQbn6/jz1YCezoXqikLEi4ejDBLpwFibO8aM0W/ZhVYynMpI46N9q3E26W8Xc9EwjsL7ObwRPEUUHguzoSsqMttGoK2g=
Message-ID: <f36b08ee0711210423nf2832a7w56cba9252a1df830@mail.gmail.com>
Date: Wed, 21 Nov 2007 14:23:56 +0200
From: "Yakov Lerner" <iler.ml@gmail.com>
To: "Kernel Linux" <linux-kernel@vger.kernel.org>
Subject: fork manpage wrt file locks
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Manpage 'man 2 fork' says:
                 'File locks ... are not inherited.'
This is true for POSIX locks,  but not for flock-type locks.
This  phrase comes directly  from posix fork manpage,
which is not aware of flock-style locks.

Maybe fork manpage should rather say:

        ... POSIX file locks are not inherited (fcntl(2)).
        Flock-style locks are inherited (see flock(2)) ...
?

Yakov
