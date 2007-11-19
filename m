Return-Path: <linux-kernel-owner+w=401wt.eu-S1754444AbXKSOKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444AbXKSOKy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 09:10:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752906AbXKSOKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 09:10:45 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:58921 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbXKSOKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 09:10:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=jPoPyUyo1THIPhEnfKUciyHjBOD31sD555wxFATnP1UATKWN/KqAkXqwxBo/d2ZiqSEJ3g2PWZbaBoKcgV+ou3KDaixki83o0HhECjU73zSnk7pE1/Pr9FUbcFrKM5Ix2yeNsYVIKBvyy63MTtr5kj3DnqUbwdJgG8zCmNx1giU=
Message-ID: <f36b08ee0711190610g22b10551hb31b77e54fe46794@mail.gmail.com>
Date: Mon, 19 Nov 2007 16:10:44 +0200
From: "Yakov Lerner" <iler.ml@gmail.com>
To: "Kernel Linux" <linux-kernel@vger.kernel.org>
Subject: =?WINDOWS-1252?Q?manual_page_'ack_to_Inbox_Arch?= =?WINDOWS-1252?Q?iveReport_SpamDelete_More_Acti?= =?WINDOWS-1252?Q?ons_1_of_584_Older_=9B_manual_pa?= =?WINDOWS-1252?Q?ge_'man_2_fork'_wrt_file_locks?=
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Manual page 'man 2 fork' says:
                  'File locks ... are not inherited.'
This is true for POSIX locks (fcntl-style locks).

But flock-style locks (aka bsd-style locks) are not inherited across
fork, correct ?

Would not it be more helpful if fork manpage said:

         POSIX file locks(fcntl(2)) are not inherited.
         flock-style locks are inherited (see flock(2))

?

Yakov
