Return-Path: <linux-kernel-owner+w=401wt.eu-S1757103AbYHTBMO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757103AbYHTBMO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 21:12:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755467AbYHTBKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 21:10:45 -0400
Received: from qmta10.westchester.pa.mail.comcast.net ([76.96.62.17]:47850
	"EHLO QMTA10.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755013AbYHTBKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 21:10:43 -0400
X-Authority-Analysis: v=1.0 c=1 a=XrLxHPN_-4yA0B6r870A:9
 a=SpDqq92kgi6fDmPuyrwKJAGQrMMA:4 a=b8hG5vVbyAkA:10
Date: Tue, 19 Aug 2008 21:10:39 -0400
From: Frank Peters <frank.peters@comcast.net>
To: linux-kernel@vger.kernel.org
Subject: 2.6.26 Breaks USB Fax Modem
Message-Id: <20080819211039.a273679f.frank.peters@comcast.net>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

After updating the kernel from 2.6.25 to 2.6.26, I now experience
severe problems when trying to send a fax using an external USB
modem.  Using either HylaFAX or efax facsimile software, the fax
transmission will just suddenly hang at some point before completion.
Neither the fax log or the kernel log will show any error or other
anomaly.  Rebooting the system with kernel 2.6.25 will allow me
to send faxes without problem.

Nothing on my machine has changed between 2.6.25 and 2.6.26 and
the same configuration was used to compile both versions. 

The cdc-acm module is responsible for communicating with the USB
modem and I suspect that it is at fault.

Has this problem been reported by anyone else?  How can I further
debug this problem?  As I mentioned, no log shows any error message
of any kind.  The logs from the fax software may indicate an
"unspecified error" but will usually just show that the data
stream has been abruptly halted.

Please cc to me directly since I am not subscribed to the list.

Frank Peters

