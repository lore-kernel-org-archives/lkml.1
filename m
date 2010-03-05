Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322Ab0CEQwe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 11:52:34 -0500
Received: from mx2.zhaw.ch ([160.85.104.51]:41537 "EHLO mx2.zhaw.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753235Ab0CEQwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 11:52:32 -0500
From: Tobias Klauser <tklauser@distanz.ch>
To: linux-serial@vger.kernel.org
Cc: gregkh@suse.de, nios2-dev@sopc.et.ntust.edu.tw,
       linux-kernel@vger.kernel.org, Tobias Klauser <tklauser@distanz.ch>
Subject: [PATCHv3 0/2] serial: Drivers for Altera UARTs
Date: Fri,  5 Mar 2010 17:52:21 +0100
Message-Id: <cover.1267807169.git.klto@zhaw.ch>
X-Mailer: git-send-email 1.6.3.3
X-PMX-Version: 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2010.3.5.164226
X-PerlMx-Spam: Gauge=X, Probability=10%, Report='
 TO_IN_SUBJECT 0.5, BODY_SIZE_1000_LESS 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_600_699 0, BODY_SIZE_7000_LESS 0, TO_NO_NAME 0, __HAS_MSGID 0, __HAS_X_MAILER 0, __MIME_TEXT_ONLY 0, __SANE_MSGID 0, __TO_MALFORMED_2 0'
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the third version of the patchset to add the serial drivers for the
Altera UARTs. I made the corrections suggested by Alan Cox on top of the second
version submitted on 01 Mar 2010.

Changes from v2 to v3:

 - altera_uart: Copy old termios settings back and set baud rate
 - altera_uart: Remove board specific DTR/DCD macros

Changes from v1 to v2:

 - altera_jtaguart: Implement altera_jtaguart_set_termios
 - altera_jtaguart: Protect port.tty in altera_jtaguart_rx_chars
 - altera_uart, altera_jtaguart: Don't depend on EMBEDDED
 - altera_jtaguart: Correct check for co->index
 - altera_uart: Correct check for co->index

Thanks,
Tobias
