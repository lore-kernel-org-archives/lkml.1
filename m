Return-Path: <linux-kernel-owner+w=401wt.eu-S1758019AbZJSX4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758019AbZJSX4A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 19:56:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755088AbZJSX4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 19:56:00 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:36004 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753781AbZJSXz7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 19:55:59 -0400
X-Greylist: delayed 375 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Oct 2009 19:55:59 EDT
Message-Id: <1255996564.10560.1340920621@webmail.messagingengine.com>
X-Sasl-Enc: TogQ+tWTmjYTEg/KEIDVTuuaXhcqTPrePlTdpl0gCMBZ 1255996564
From: myuboot@fastmail.fm
To: linux-kernel@vger.kernel.org, "linux-mips" <linux-mips@linux-mips.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: MessagingEngine.com Webmail Interface
References: <1255735395.30097.1340523469@webmail.messagingengine.com>
 <4AD906D8.3020404@caviumnetworks.com>
Subject: serial port 8250 messed up after coverting from little endian to big
 endian on kernel  2.6.31
In-Reply-To: <4AD906D8.3020404@caviumnetworks.com>
Date: Mon, 19 Oct 2009 18:56:04 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am trying to bringup a MIPS32 board using 2.6.31. It is working in
little endian mode. After changing the board's hardware from little
endian to bit endian, the serial port print messed up. It prints now
something like - "‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡‡" on the screen. When I trace the
execution, I can see the string the kernel is trying print is correct -
"Linux version 2.6.31 ..." and etc.

I guess it means the initialization of the serial port is not properly
done. But I am not sure where I should check for the problem. The serial
port device I am using is 8250. Please give me some advise.

Thanks. 
