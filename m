Return-Path: <linux-kernel-owner+w=401wt.eu-S932172AbZHYVvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172AbZHYVvH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 17:51:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754460AbZHYVvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 17:51:06 -0400
Received: from smtp-out3.blueyonder.co.uk ([195.188.213.6]:33808 "EHLO
	smtp-out3.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754055AbZHYVvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 17:51:05 -0400
Message-ID: <4A944EAC.60609@blueyonder.co.uk>
Date: Tue, 25 Aug 2009 21:50:52 +0100
From: Sid Boyce <sboyce@blueyonder.co.uk>
Reply-To: Sid Boyce <sboyce@blueyonder.co.uk>
Organization: blueyonder.co.uk
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.9.1.1) Gecko/20090715 SUSE/3.0b3-3.4 Thunderbird/3.0b3
MIME-Version: 1.0
To: LKML Mailing List <linux-kernel@vger.kernel.org>
Subject: Floppy wait problem in 2.6.31-rc7 and -rc7-git
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Occurs if floppy is enabled in the BIOS but is absent and also one
report that it happens if there is no floppy in the drive.
Looks like a regression as I can remember this happening going way back.
# dmesg|grep fd0
Floppy drive(s): fd0 is 1.44M
end_request: I/O error, dev fd0, sector 0
end_request: I/O error, dev fd0, sector 0
Buffer I/O error on device fd0, logical block 0
end_request: I/O error, dev fd0, sector 0
Buffer I/O error on device fd0, logical block 0
end_request: I/O error, dev fd0, sector 0
Buffer I/O error on device fd0, logical block 0
Regards
Sid.
-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

