Return-Path: <linux-kernel-owner+w=401wt.eu-S1756203AbYIOUf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203AbYIOUf1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 16:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754237AbYIOUfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 16:35:18 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:50583 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748AbYIOUfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 16:35:17 -0400
Message-ID: <48CEC71F.3000006@manoweb.com>
Date: Mon, 15 Sep 2008 13:35:43 -0700
From: Alessio Sangalli <alesan@manoweb.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Driver for tightly coupled memory
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/gOXVEzqZ6Zwj5/UKz7Rl9cD4zW+qoHTt2EmW
 DpZ+CEQ7L4p/HFeOSZMJH7UV4uYLJxpP0IdIusjPN/bDTvXivz
 QxSxZy82L0utQ2ooj2IwA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, the platform I am working on right now (ARM) has a so called 'TCM'
(tightly coupled memory) that is some 8 to 32kB of SRAM in the chip, no
waitstates, very high bandwidth, and it is possible to access it *while*
accessing main memory. It may be a very good thing (for example) to
implement a software FIFO to be used in ISRs or such.

Do you know of any implementation of such software FIFO or any other
kernel driver for TCMs?

bye
Alessio

