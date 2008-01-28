Return-Path: <linux-kernel-owner+w=401wt.eu-S1760335AbYA1MP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760335AbYA1MP3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 07:15:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751730AbYA1MPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 07:15:22 -0500
Received: from ms01.sssup.it ([193.205.80.99]:34201 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751499AbYA1MPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 07:15:22 -0500
X-Greylist: delayed 3599 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Jan 2008 07:15:19 EST
Message-ID: <479DB934.6090806@gandalf.sssup.it>
Date: Mon, 28 Jan 2008 12:15:00 +0100
From: michael <trimarchi@gandalf.sssup.it>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: hskinnemoen@atmel.com
Subject: at91sam9260 wakeup on serial port
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I implement a little patch (ndr just for a try) for the atmel serial 
driver atmel_serial.c to wakeup the system when it is in suspend-ram state.
I reconfigure the RXD pin as a gpio in suspend function and restore it 
in the resume function. It is the correct way?

Regards Michael

