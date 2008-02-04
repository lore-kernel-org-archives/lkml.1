Return-Path: <linux-kernel-owner+w=401wt.eu-S1755680AbYBDNmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680AbYBDNmX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 08:42:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752148AbYBDNmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 08:42:07 -0500
Received: from wx-out-0506.google.com ([66.249.82.225]:38397 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbYBDNmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 08:42:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:from;
        b=h+nrF6bi9TkkaNihJpt57m2qrLM6azFAq7SPOG52fx0mIhygmqMrdh5QrbmuRIiwLg6wdrGR5BEMQZMzS068pLBKIE8fWh5KsS5mXVESfT7s40tNclF99qMmc+0B/fAhMau/MKYEAVrg4Jf2wid//h4eB/XRge53zDPCPuSNnIY=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: 
Date: Mon,  4 Feb 2008 14:40:18 +0100
Message-Id: <1202132440-26648-1-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bart,

here are the pending ide-tape patches reworked which incorporate all review
points raised so far. Several new patches are appended to the original series
which i thought would be reasonable to sumbit along with the others. Also,
i've applied "ide-tape: dump gcw fields on error in idetape_identify_device()"
which is #12 and which you can simply ignore. Furthermore, #32 from the original
series got split up into the different logical changes it dealt with, as you
requested.


 Documentation/feature-removal-schedule.txt |   14 +-
 drivers/ide/ide-tape.c                     | 2764 +++++++++++++---------------
 2 files changed, 1325 insertions(+), 1453 deletions(-)
