Return-Path: <linux-kernel-owner+w=401wt.eu-S1756051AbYIIJA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbYIIJA7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 05:00:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754628AbYIIJAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 05:00:51 -0400
Received: from net3-nl-smtp-02.vevida.net ([77.94.249.26]:38616 "EHLO
	net3-nl-smtp-02.vevida.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754619AbYIIJAu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 05:00:50 -0400
X-Greylist: delayed 571 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Sep 2008 05:00:50 EDT
MIME-Version: 1.0
X-Mailer: AtMail PHP 4.52
Message-ID: <11947.1220950130@langendorff.nl>
To: <linux-kernel@vger.kernel.org>
Reply-To: niels@langendorff.nl
Content-Type: text/plain; charset="utf-8"
X-Origin: 82.210.249.81
X-Atmail-Account: niels@langendorff.nl
Date: Tue, 9 Sep 2008 10:48:50 +0200
Subject: GPIO active high/low handling on embedded devices
From: niels@langendorff.nl
Cc: <niels@langendorff.nl>
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I missing some functionality in the current GPIO interface which I am using in an
embedded environment.
It is not possible to specify if an output is low or high active on arch level.

IOW I want to activate or deactivate (on driver level) an output without having
to know if an output is high or low active, which should be specified on arch level.

Currently I created a structure with the gpio number and a boolean is_inverted,
and I added two functions called gpio_activate and gpio_deactivate, these
functions allow me to control the hardware independent of the low level
implementation, for example gpio_activate(RESET).

My question is if there is already such an solution or will the GPIO interface
support this functionality in the future?


Best regards,


Niels Langendorff


