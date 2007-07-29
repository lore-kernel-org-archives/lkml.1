Return-Path: <linux-kernel-owner+w=401wt.eu-S1762629AbXG2MwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762629AbXG2MwR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 08:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760374AbXG2MwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 08:52:05 -0400
Received: from dsl017-112-251.lax1.dsl.speakeasy.net ([69.17.112.251]:39304
	"EHLO NickAndBarb.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751691AbXG2MwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 08:52:01 -0400
X-Greylist: delayed 345 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 Jul 2007 08:52:00 EDT
Date: Sun, 29 Jul 2007 05:48:13 -0700
From: Nick Pasich <NewsLetters@NickAndBarb.net>
To: Adam Kropelin <akropel1@rochester.rr.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Nick Pasich <NewsLetters@NickAndBarb.net>,
       linux-usb-devel@lists.sourceforge.net,
       Greg Kroah-Hartman <greg@kroah.com>,
       Al Borchers <alborchers@steinerpoint.com>, linux-kernel@vger.kernel.org,
       Peter Berger <pberger@brimson.com>
Subject: Re: [linux-usb-devel] Edgeport UPS Monitoring Problems
Message-ID: <20070729124813.GA30633@69.17.112.251>
References: <20070727203708.GA10839@NICK2> <20070727152254.202959c1.akpm@linux-foundation.org> <003701c7d16c$8c72b7b0$03c8a8c0@kroptech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <003701c7d16c$8c72b7b0$03c8a8c0@kroptech.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Adam,

Here's the dmesg output ......

    ---( Nick )---

*******************************************************************************
*******************************************************************************

Jul 29 05:19:28 NICK2 kernel: drivers/usb/serial/io_edgeport.c: get_string - USB String ID = 1
Jul 29 05:19:28 NICK2 kernel: drivers/usb/serial/io_edgeport.c: get_string - USB String Inside Out Networks
Jul 29 05:19:28 NICK2 kernel: drivers/usb/serial/io_edgeport.c: get_string - USB String ID = 2
Jul 29 05:19:28 NICK2 kernel: drivers/usb/serial/io_edgeport.c: get_string - USB String Edgeport/4
Jul 29 05:19:28 NICK2 kernel: drivers/usb/serial/io_edgeport.c: get_epic_descriptor result = -32
Jul 29 05:19:28 NICK2 kernel: drivers/usb/serial/io_edgeport.c: getting manufacturer descriptor
Jul 29 05:19:28 NICK2 kernel: drivers/usb/serial/io_edgeport.c: rom_read - ff, 7c00, 960
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c: **Manufacturer Descriptor
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c:   RomSize:        8K
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c:   RamSize:        32K
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c:   CpuRev:         1
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c:   BoardRev:       3
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c:   NumPorts:       4
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c:   DescDate:       2/8/2002
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c:   SerialNumber: V21274923-0
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c:   AssemblyNumber: 
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c:   OemAssyNumber:  
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c:   UartType:       1
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c:   IonPid:         1
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c:   IonConfig:      0
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c: getting boot descriptor
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c: rom_read - ff, 7fc0, 64
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c: **Boot Descriptor:
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c:   BootCodeLength: 7044
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c:   MajorVersion:   1
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c:   MinorVersion:   13
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c:   BuildNumber:    7
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c:   Capabilities:   0x1
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c:   UConfig0:       241
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c:   UConfig1:       127
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c: **Product Information:
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c:   ProductId             1
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c:   NumPorts              4
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c:   ProdInfoVer           0
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c:   IsServer              0
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c:   IsRS232               1
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c:   IsRS422               0
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c:   IsRS485               0
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c:   RomSize               8
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c:   RamSize               32
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c:   CpuRev                1
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c:   BoardRev              3
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c:   BootMajorVersion      1.13.7
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c:   FirmwareMajorVersion  1.16.4
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c:   ManufactureDescDate   2/8/2002
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c:   iDownloadFile         0xff
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c:   EpicVer               0
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_startup - time 1 146052173
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c: downloading firmware version (930) 1.16.4
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c: sram_write - ff, 0, 6
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c: sram_write - ff, b, 3
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c: sram_write - ff, 13, 3
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c: sram_write - ff, 1b, 3
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c: sram_write - ff, 23, 3
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c: sram_write - ff, 2b, 3
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c: sram_write - ff, 33, 3
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c: sram_write - ff, 3b, 3
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c: sram_write - ff, 43, 3
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c: sram_write - ff, 4b, 3
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c: sram_write - ff, 53, 3
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c: sram_write - ff, 7b, 3
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c: sram_write - ff, 80, 7
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c: sram_write - ff, 3000, 2178
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c: sram_write - ff, 4000, 15381
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c: sram_write - ff, 7fc6, 4
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c: sram_write - ff, 7c15, 330
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c: sending exec_dl_code
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_startup - time 2 146052474
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c: Current Boot Image version 1.13.7
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c: Boot Image -- already up to date
Jul 29 05:19:29 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_startup - time 3 146052475
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_open - port 0
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: send_iosp_ext_cmd - 0, 0
Jul 29 05:20:07 NICK2 kernel: edgeport_4 ttyUSB0: write_cmd_usb - length = 3, data = c8 00 00 
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: write_cmd_usb - ALLOCATE URB ee9ce680 (outstanding 1)
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_bulk_out_cmd_callback
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_bulk_out_cmd_callback - FREE URB ee9ce680 (outstanding 0)
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_interrupt_callback
Jul 29 05:20:07 NICK2 kernel: usb 2-2: edge_interrupt_callback - length = 10, data = 03 00 00 00 00 00 00 00 00 00 
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_interrupt_callback - bytes_avail=3, rxBytesAvail=3, read_in_progress=0
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_interrupt_callback - posting a read
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_bulk_in_callback
Jul 29 05:20:07 NICK2 kernel: usb 2-2: edge_bulk_in_callback - length = 3, data = d0 00 0f 
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_bulk_in_callback - Received = 3, rxBytesAvail 0
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: process_rcvd_data
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: process_rcvd_data - Hdr1=D0 Hdr2=00
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: process_rcvd_status - port 0
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: process_rcvd_status - Port 0 Open Response Inital MSR = 00 TxBufferSize = 1024
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: handle_new_msr 00
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: change_port_settings - port 0
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: change_port_settings - data bits = 8
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: change_port_settings - parity = none
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: change_port_settings - stop bits = 1
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: change_port_settings - RTS/CTS is disabled
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: send_iosp_ext_cmd - 5, 17
Jul 29 05:20:07 NICK2 kernel: edgeport_4 ttyUSB0: write_cmd_usb - length = 3, data = c8 05 11 
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: write_cmd_usb - ALLOCATE URB ee9ce680 (outstanding 1)
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: send_iosp_ext_cmd - 6, 19
Jul 29 05:20:07 NICK2 kernel: edgeport_4 ttyUSB0: write_cmd_usb - length = 3, data = c8 06 13 
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: write_cmd_usb - ALLOCATE URB df413c80 (outstanding 2)
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: change_port_settings - INBOUND XON/XOFF is disabled
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: change_port_settings - OUTBOUND XON/XOFF is enabled, XON = 11, XOFF = 13
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: send_iosp_ext_cmd - 3, 0
Jul 29 05:20:07 NICK2 kernel: edgeport_4 ttyUSB0: write_cmd_usb - length = 3, data = c8 03 00 
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: write_cmd_usb - ALLOCATE URB ed54c200 (outstanding 3)
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: send_iosp_ext_cmd - 4, 8
Jul 29 05:20:07 NICK2 kernel: edgeport_4 ttyUSB0: write_cmd_usb - length = 3, data = c8 04 08 
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: write_cmd_usb - ALLOCATE URB ca611560 (outstanding 4)
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: LCR - write to send_cmd_write_uart_register register 0x03
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: SendCmdWriteUartReg - Not writing to MCR Register
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: MCR - write to send_cmd_write_uart_register register 0x0b
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: SendCmdWriteUartReg - Not writing to MCR Register
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: change_port_settings - baud rate = 9600
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: SendCmdWriteBaudRate - NOT Setting baud rate for port = 0, baud = 9600
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_bulk_out_cmd_callback
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_bulk_out_cmd_callback - FREE URB ee9ce680 (outstanding 3)
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_bulk_out_cmd_callback
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_bulk_out_cmd_callback - FREE URB df413c80 (outstanding 2)
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_bulk_out_cmd_callback
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_bulk_out_cmd_callback - FREE URB ed54c200 (outstanding 1)
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_bulk_out_cmd_callback
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_bulk_out_cmd_callback - FREE URB ca611560 (outstanding 0)
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_open(0) - Initialize TX fifo to 1024 bytes
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_open exited
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_ioctl - port 0, cmd = 0x5401
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_ioctl - port 0, cmd = 0x540b
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_ioctl - port 0, cmd = 0x5402
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_set_termios - clfag 000008bb iflag 00000004
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_set_termios - old clfag 00000cbd old iflag 00000500
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_set_termios - port 0
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: change_port_settings - port 0
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: change_port_settings - data bits = 8
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: change_port_settings - parity = none
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: change_port_settings - stop bits = 1
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: change_port_settings - RTS/CTS is disabled
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: send_iosp_ext_cmd - 3, 0
Jul 29 05:20:07 NICK2 kernel: edgeport_4 ttyUSB0: write_cmd_usb - length = 3, data = c8 03 00 
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: write_cmd_usb - ALLOCATE URB ed54c200 (outstanding 1)
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: send_iosp_ext_cmd - 4, 0
Jul 29 05:20:07 NICK2 kernel: edgeport_4 ttyUSB0: write_cmd_usb - length = 3, data = c8 04 00 
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: write_cmd_usb - ALLOCATE URB df413c80 (outstanding 2)
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: LCR - write to send_cmd_write_uart_register register 0x03
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_bulk_out_cmd_callback
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_bulk_out_cmd_callback - FREE URB ed54c200 (outstanding 1)
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_bulk_out_cmd_callback
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_bulk_out_cmd_callback - FREE URB df413c80 (outstanding 0)
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: SendCmdWriteUartReg - Not writing to MCR Register
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: MCR - write to send_cmd_write_uart_register register 0x0b
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: SendCmdWriteUartReg - Not writing to MCR Register
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: change_port_settings - baud rate = 2400
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: SendCmdWriteBaudRate - NOT Setting baud rate for port = 0, baud = 2400
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_ioctl - port 0, cmd = 0x540b
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write - port 0
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write(0) of 1 byte(s) Fifo room  1024 -- will copy 1 bytes
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write - copy 1 bytes of 1024 into fifo 
Jul 29 05:20:07 NICK2 kernel: edgeport_4 ttyUSB0: edge_write - length = 1, data = 59 
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: send_more_port_data(0)
Jul 29 05:20:07 NICK2 kernel: edgeport_4 ttyUSB0: send_more_port_data - length = 1, data = 59 
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: send_more_port_data wrote 1 byte(s) TxCredit 1023, Fifo 0
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_interrupt_callback
Jul 29 05:20:07 NICK2 kernel: usb 2-2: edge_interrupt_callback - length = 10, data = 04 00 01 00 00 00 00 00 00 00 
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_interrupt_callback - bytes_avail=4, rxBytesAvail=4, read_in_progress=0
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_interrupt_callback - posting a read
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_interrupt_callback - txcredits for port0 = 1024
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: send_more_port_data(0)
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: send_more_port_data(0) EXIT - fifo 0, PendingWrite = 1
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_bulk_out_data_callback
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: send_more_port_data(0)
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: send_more_port_data(0) EXIT - fifo 0, PendingWrite = 0
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_bulk_in_callback
Jul 29 05:20:07 NICK2 kernel: usb 2-2: edge_bulk_in_callback - length = 4, data = 88 0f 88 0f 
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_bulk_in_callback - Received = 4, rxBytesAvail 0
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: process_rcvd_data
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: process_rcvd_data - Hdr1=88 Hdr2=0F
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: process_rcvd_status - port 0
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: process_rcvd_status - Port 0 MSR Status = 0f
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: handle_new_msr 0f
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: process_rcvd_data - Hdr1=88 Hdr2=0F
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: process_rcvd_status - port 0
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: process_rcvd_status - Port 0 MSR Status = 0f
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: handle_new_msr 0f
Jul 29 05:20:07 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write wrote 1 byte(s) TxCredits 1024, Fifo 0
Jul 29 05:20:08 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_ioctl - port 0, cmd = 0x540b
Jul 29 05:20:08 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write - port 0
Jul 29 05:20:08 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write(0) of 1 byte(s) Fifo room  1024 -- will copy 1 bytes
Jul 29 05:20:08 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write - copy 1 bytes of 1023 into fifo 
Jul 29 05:20:08 NICK2 kernel: edgeport_4 ttyUSB0: edge_write - length = 1, data = 59 
Jul 29 05:20:08 NICK2 kernel: drivers/usb/serial/io_edgeport.c: send_more_port_data(0)
Jul 29 05:20:08 NICK2 kernel: edgeport_4 ttyUSB0: send_more_port_data - length = 1, data = 59 
Jul 29 05:20:08 NICK2 kernel: drivers/usb/serial/io_edgeport.c: send_more_port_data wrote 1 byte(s) TxCredit 1023, Fifo 0
Jul 29 05:20:08 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write wrote 1 byte(s) TxCredits 1023, Fifo 0
Jul 29 05:20:08 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_chars_in_buffer
Jul 29 05:20:08 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_chars_in_buffer(port 0) - returns 1
Jul 29 05:20:08 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_bulk_out_data_callback
Jul 29 05:20:08 NICK2 kernel: drivers/usb/serial/io_edgeport.c: send_more_port_data(0)
Jul 29 05:20:08 NICK2 kernel: drivers/usb/serial/io_edgeport.c: send_more_port_data(0) EXIT - fifo 0, PendingWrite = 0
Jul 29 05:20:08 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write_room
Jul 29 05:20:08 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_interrupt_callback
Jul 29 05:20:08 NICK2 kernel: usb 2-2: edge_interrupt_callback - length = 10, data = 04 00 01 00 00 00 00 00 00 00 
Jul 29 05:20:08 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_interrupt_callback - bytes_avail=4, rxBytesAvail=4, read_in_progress=0
Jul 29 05:20:08 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_interrupt_callback - posting a read
Jul 29 05:20:08 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_interrupt_callback - txcredits for port0 = 1024
Jul 29 05:20:08 NICK2 kernel: drivers/usb/serial/io_edgeport.c: send_more_port_data(0)
Jul 29 05:20:08 NICK2 kernel: drivers/usb/serial/io_edgeport.c: send_more_port_data(0) EXIT - fifo 0, PendingWrite = 0
Jul 29 05:20:08 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_bulk_in_callback
Jul 29 05:20:08 NICK2 kernel: usb 2-2: edge_bulk_in_callback - length = 4, data = 88 0f 88 0f 
Jul 29 05:20:08 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_bulk_in_callback - Received = 4, rxBytesAvail 0
Jul 29 05:20:08 NICK2 kernel: drivers/usb/serial/io_edgeport.c: process_rcvd_data
Jul 29 05:20:08 NICK2 kernel: drivers/usb/serial/io_edgeport.c: process_rcvd_data - Hdr1=88 Hdr2=0F
Jul 29 05:20:09 NICK2 kernel: drivers/usb/serial/io_edgeport.c: process_rcvd_status - port 0
Jul 29 05:20:09 NICK2 kernel: drivers/usb/serial/io_edgeport.c: process_rcvd_status - Port 0 MSR Status = 0f
Jul 29 05:20:09 NICK2 kernel: drivers/usb/serial/io_edgeport.c: handle_new_msr 0f
Jul 29 05:20:09 NICK2 kernel: drivers/usb/serial/io_edgeport.c: process_rcvd_data - Hdr1=88 Hdr2=0F
Jul 29 05:20:09 NICK2 kernel: drivers/usb/serial/io_edgeport.c: process_rcvd_status - port 0
Jul 29 05:20:09 NICK2 kernel: drivers/usb/serial/io_edgeport.c: process_rcvd_status - Port 0 MSR Status = 0f
Jul 29 05:20:09 NICK2 kernel: drivers/usb/serial/io_edgeport.c: handle_new_msr 0f
Jul 29 05:20:09 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write_room - port 0
Jul 29 05:20:09 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write_room - returns 1024
Jul 29 05:20:09 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_chars_in_buffer
Jul 29 05:20:09 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write_room
Jul 29 05:20:09 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write_room - port 0
Jul 29 05:20:09 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write_room - returns 1024
Jul 29 05:20:10 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_chars_in_buffer
Jul 29 05:20:10 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write_room
Jul 29 05:20:10 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write_room - port 0
Jul 29 05:20:10 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write_room - returns 1024
Jul 29 05:20:11 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write - port 0
Jul 29 05:20:11 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write(0) of 1 byte(s) Fifo room  1024 -- will copy 1 bytes
Jul 29 05:20:11 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write - copy 1 bytes of 1022 into fifo 
Jul 29 05:20:11 NICK2 kernel: edgeport_4 ttyUSB0: edge_write - length = 1, data = 59 
Jul 29 05:20:11 NICK2 kernel: drivers/usb/serial/io_edgeport.c: send_more_port_data(0)
Jul 29 05:20:11 NICK2 kernel: edgeport_4 ttyUSB0: send_more_port_data - length = 1, data = 59 
Jul 29 05:20:11 NICK2 kernel: drivers/usb/serial/io_edgeport.c: send_more_port_data wrote 1 byte(s) TxCredit 1023, Fifo 0
Jul 29 05:20:11 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write wrote 1 byte(s) TxCredits 1023, Fifo 0
Jul 29 05:20:11 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_chars_in_buffer
Jul 29 05:20:11 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_chars_in_buffer(port 0) - returns 1
Jul 29 05:20:11 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_bulk_out_data_callback
Jul 29 05:20:11 NICK2 kernel: drivers/usb/serial/io_edgeport.c: send_more_port_data(0)
Jul 29 05:20:11 NICK2 kernel: drivers/usb/serial/io_edgeport.c: send_more_port_data(0) EXIT - fifo 0, PendingWrite = 0
Jul 29 05:20:11 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write_room
Jul 29 05:20:11 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_interrupt_callback
Jul 29 05:20:11 NICK2 kernel: usb 2-2: edge_interrupt_callback - length = 10, data = 04 00 01 00 00 00 00 00 00 00 
Jul 29 05:20:11 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_interrupt_callback - bytes_avail=4, rxBytesAvail=4, read_in_progress=0
Jul 29 05:20:11 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_interrupt_callback - posting a read
Jul 29 05:20:11 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_interrupt_callback - txcredits for port0 = 1024
Jul 29 05:20:11 NICK2 kernel: drivers/usb/serial/io_edgeport.c: send_more_port_data(0)
Jul 29 05:20:11 NICK2 kernel: drivers/usb/serial/io_edgeport.c: send_more_port_data(0) EXIT - fifo 0, PendingWrite = 0
Jul 29 05:20:11 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_bulk_in_callback
Jul 29 05:20:11 NICK2 kernel: usb 2-2: edge_bulk_in_callback - length = 4, data = 88 0f 88 0f 
Jul 29 05:20:11 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_bulk_in_callback - Received = 4, rxBytesAvail 0
Jul 29 05:20:11 NICK2 kernel: drivers/usb/serial/io_edgeport.c: process_rcvd_data
Jul 29 05:20:11 NICK2 kernel: drivers/usb/serial/io_edgeport.c: process_rcvd_data - Hdr1=88 Hdr2=0F
Jul 29 05:20:11 NICK2 kernel: drivers/usb/serial/io_edgeport.c: process_rcvd_status - port 0
Jul 29 05:20:11 NICK2 kernel: drivers/usb/serial/io_edgeport.c: process_rcvd_status - Port 0 MSR Status = 0f
Jul 29 05:20:11 NICK2 kernel: drivers/usb/serial/io_edgeport.c: handle_new_msr 0f
Jul 29 05:20:11 NICK2 kernel: drivers/usb/serial/io_edgeport.c: process_rcvd_data - Hdr1=88 Hdr2=0F
Jul 29 05:20:11 NICK2 kernel: drivers/usb/serial/io_edgeport.c: process_rcvd_status - port 0
Jul 29 05:20:11 NICK2 kernel: drivers/usb/serial/io_edgeport.c: process_rcvd_status - Port 0 MSR Status = 0f
Jul 29 05:20:11 NICK2 kernel: drivers/usb/serial/io_edgeport.c: handle_new_msr 0f
Jul 29 05:20:11 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write_room - port 0
Jul 29 05:20:11 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write_room - returns 1024
Jul 29 05:20:11 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_chars_in_buffer
Jul 29 05:20:11 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write_room
Jul 29 05:20:11 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write_room - port 0
Jul 29 05:20:11 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write_room - returns 1024
Jul 29 05:20:12 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_chars_in_buffer
Jul 29 05:20:12 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write_room
Jul 29 05:20:12 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write_room - port 0
Jul 29 05:20:12 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write_room - returns 1024
Jul 29 05:20:13 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write - port 0
Jul 29 05:20:13 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write(0) of 1 byte(s) Fifo room  1024 -- will copy 1 bytes
Jul 29 05:20:13 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write - copy 1 bytes of 1021 into fifo 
Jul 29 05:20:13 NICK2 kernel: edgeport_4 ttyUSB0: edge_write - length = 1, data = 59 
Jul 29 05:20:13 NICK2 kernel: drivers/usb/serial/io_edgeport.c: send_more_port_data(0)
Jul 29 05:20:13 NICK2 kernel: edgeport_4 ttyUSB0: send_more_port_data - length = 1, data = 59 
Jul 29 05:20:13 NICK2 kernel: drivers/usb/serial/io_edgeport.c: send_more_port_data wrote 1 byte(s) TxCredit 1023, Fifo 0
Jul 29 05:20:13 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write wrote 1 byte(s) TxCredits 1023, Fifo 0
Jul 29 05:20:13 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_chars_in_buffer
Jul 29 05:20:13 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_chars_in_buffer(port 0) - returns 1
Jul 29 05:20:13 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write_room
Jul 29 05:20:13 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_bulk_out_data_callback
Jul 29 05:20:13 NICK2 kernel: drivers/usb/serial/io_edgeport.c: send_more_port_data(0)
Jul 29 05:20:13 NICK2 kernel: drivers/usb/serial/io_edgeport.c: send_more_port_data(0) EXIT - fifo 0, PendingWrite = 0
Jul 29 05:20:13 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write_room - port 0
Jul 29 05:20:13 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_interrupt_callback
Jul 29 05:20:13 NICK2 kernel: usb 2-2: edge_interrupt_callback - length = 10, data = 04 00 01 00 00 00 00 00 00 00 
Jul 29 05:20:13 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_interrupt_callback - bytes_avail=4, rxBytesAvail=4, read_in_progress=0
Jul 29 05:20:13 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_interrupt_callback - posting a read
Jul 29 05:20:13 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_interrupt_callback - txcredits for port0 = 1024
Jul 29 05:20:13 NICK2 kernel: drivers/usb/serial/io_edgeport.c: send_more_port_data(0)
Jul 29 05:20:13 NICK2 kernel: drivers/usb/serial/io_edgeport.c: send_more_port_data(0) EXIT - fifo 0, PendingWrite = 0
Jul 29 05:20:13 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_bulk_in_callback
Jul 29 05:20:13 NICK2 kernel: usb 2-2: edge_bulk_in_callback - length = 4, data = 88 0f 88 0f 
Jul 29 05:20:13 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_bulk_in_callback - Received = 4, rxBytesAvail 0
Jul 29 05:20:13 NICK2 kernel: drivers/usb/serial/io_edgeport.c: process_rcvd_data
Jul 29 05:20:13 NICK2 kernel: drivers/usb/serial/io_edgeport.c: process_rcvd_data - Hdr1=88 Hdr2=0F
Jul 29 05:20:13 NICK2 kernel: drivers/usb/serial/io_edgeport.c: process_rcvd_status - port 0
Jul 29 05:20:13 NICK2 kernel: drivers/usb/serial/io_edgeport.c: process_rcvd_status - Port 0 MSR Status = 0f
Jul 29 05:20:13 NICK2 kernel: drivers/usb/serial/io_edgeport.c: handle_new_msr 0f
Jul 29 05:20:13 NICK2 kernel: drivers/usb/serial/io_edgeport.c: process_rcvd_data - Hdr1=88 Hdr2=0F
Jul 29 05:20:13 NICK2 kernel: drivers/usb/serial/io_edgeport.c: process_rcvd_status - port 0
Jul 29 05:20:13 NICK2 kernel: drivers/usb/serial/io_edgeport.c: process_rcvd_status - Port 0 MSR Status = 0f
Jul 29 05:20:13 NICK2 kernel: drivers/usb/serial/io_edgeport.c: handle_new_msr 0f
Jul 29 05:20:13 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write_room - returns 1024
Jul 29 05:20:13 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_chars_in_buffer
Jul 29 05:20:13 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write_room
Jul 29 05:20:13 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write_room - port 0
Jul 29 05:20:13 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write_room - returns 1024
Jul 29 05:20:14 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_chars_in_buffer
Jul 29 05:20:14 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write_room
Jul 29 05:20:14 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write_room - port 0
Jul 29 05:20:14 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write_room - returns 1024
Jul 29 05:20:15 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write - port 0
Jul 29 05:20:15 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write(0) of 1 byte(s) Fifo room  1024 -- will copy 1 bytes
Jul 29 05:20:15 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write - copy 1 bytes of 1020 into fifo 
Jul 29 05:20:15 NICK2 kernel: edgeport_4 ttyUSB0: edge_write - length = 1, data = 59 
Jul 29 05:20:15 NICK2 kernel: drivers/usb/serial/io_edgeport.c: send_more_port_data(0)
Jul 29 05:20:15 NICK2 kernel: edgeport_4 ttyUSB0: send_more_port_data - length = 1, data = 59 
Jul 29 05:20:15 NICK2 kernel: drivers/usb/serial/io_edgeport.c: send_more_port_data wrote 1 byte(s) TxCredit 1023, Fifo 0
Jul 29 05:20:15 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write wrote 1 byte(s) TxCredits 1023, Fifo 0
Jul 29 05:20:15 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_chars_in_buffer
Jul 29 05:20:15 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_chars_in_buffer(port 0) - returns 1
Jul 29 05:20:15 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write_room
Jul 29 05:20:15 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_bulk_out_data_callback
Jul 29 05:20:15 NICK2 kernel: drivers/usb/serial/io_edgeport.c: send_more_port_data(0)
Jul 29 05:20:15 NICK2 kernel: drivers/usb/serial/io_edgeport.c: send_more_port_data(0) EXIT - fifo 0, PendingWrite = 0
Jul 29 05:20:15 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write_room - port 0
Jul 29 05:20:15 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write_room - returns 1023
Jul 29 05:20:15 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_chars_in_buffer
Jul 29 05:20:15 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_chars_in_buffer(port 0) - returns 1
Jul 29 05:20:15 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_interrupt_callback
Jul 29 05:20:15 NICK2 kernel: usb 2-2: edge_interrupt_callback - length = 10, data = 04 00 01 00 00 00 00 00 00 00 
Jul 29 05:20:15 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_interrupt_callback - bytes_avail=4, rxBytesAvail=4, read_in_progress=0
Jul 29 05:20:15 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_interrupt_callback - posting a read
Jul 29 05:20:15 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_interrupt_callback - txcredits for port0 = 1024
Jul 29 05:20:15 NICK2 kernel: drivers/usb/serial/io_edgeport.c: send_more_port_data(0)
Jul 29 05:20:15 NICK2 kernel: drivers/usb/serial/io_edgeport.c: send_more_port_data(0) EXIT - fifo 0, PendingWrite = 0
Jul 29 05:20:15 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_bulk_in_callback
Jul 29 05:20:15 NICK2 kernel: usb 2-2: edge_bulk_in_callback - length = 4, data = 88 0f 88 0f 
Jul 29 05:20:15 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_bulk_in_callback - Received = 4, rxBytesAvail 0
Jul 29 05:20:15 NICK2 kernel: drivers/usb/serial/io_edgeport.c: process_rcvd_data
Jul 29 05:20:15 NICK2 kernel: drivers/usb/serial/io_edgeport.c: process_rcvd_data - Hdr1=88 Hdr2=0F
Jul 29 05:20:15 NICK2 kernel: drivers/usb/serial/io_edgeport.c: process_rcvd_status - port 0
Jul 29 05:20:15 NICK2 kernel: drivers/usb/serial/io_edgeport.c: process_rcvd_status - Port 0 MSR Status = 0f
Jul 29 05:20:15 NICK2 kernel: drivers/usb/serial/io_edgeport.c: handle_new_msr 0f
Jul 29 05:20:15 NICK2 kernel: drivers/usb/serial/io_edgeport.c: process_rcvd_data - Hdr1=88 Hdr2=0F
Jul 29 05:20:15 NICK2 kernel: drivers/usb/serial/io_edgeport.c: process_rcvd_status - port 0
Jul 29 05:20:15 NICK2 kernel: drivers/usb/serial/io_edgeport.c: process_rcvd_status - Port 0 MSR Status = 0f
Jul 29 05:20:15 NICK2 kernel: drivers/usb/serial/io_edgeport.c: handle_new_msr 0f
Jul 29 05:20:15 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write_room
Jul 29 05:20:15 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write_room - port 0
Jul 29 05:20:15 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write_room - returns 1024
Jul 29 05:20:15 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_chars_in_buffer
Jul 29 05:20:15 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write_room
Jul 29 05:20:15 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write_room - port 0
Jul 29 05:20:15 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write_room - returns 1024
Jul 29 05:20:16 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_chars_in_buffer
Jul 29 05:20:16 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write_room
Jul 29 05:20:16 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write_room - port 0
Jul 29 05:20:16 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write_room - returns 1024
Jul 29 05:20:17 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write - port 0
Jul 29 05:20:17 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write(0) of 1 byte(s) Fifo room  1024 -- will copy 1 bytes
Jul 29 05:20:17 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write - copy 1 bytes of 1019 into fifo 
Jul 29 05:20:17 NICK2 kernel: edgeport_4 ttyUSB0: edge_write - length = 1, data = 59 
Jul 29 05:20:17 NICK2 kernel: drivers/usb/serial/io_edgeport.c: send_more_port_data(0)
Jul 29 05:20:17 NICK2 kernel: edgeport_4 ttyUSB0: send_more_port_data - length = 1, data = 59 
Jul 29 05:20:17 NICK2 kernel: drivers/usb/serial/io_edgeport.c: send_more_port_data wrote 1 byte(s) TxCredit 1023, Fifo 0
Jul 29 05:20:17 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write wrote 1 byte(s) TxCredits 1023, Fifo 0
Jul 29 05:20:17 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_chars_in_buffer
Jul 29 05:20:17 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_chars_in_buffer(port 0) - returns 1
Jul 29 05:20:17 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write_room
Jul 29 05:20:17 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_bulk_out_data_callback
Jul 29 05:20:17 NICK2 kernel: drivers/usb/serial/io_edgeport.c: send_more_port_data(0)
Jul 29 05:20:17 NICK2 kernel: drivers/usb/serial/io_edgeport.c: send_more_port_data(0) EXIT - fifo 0, PendingWrite = 0
Jul 29 05:20:17 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write_room - port 0
Jul 29 05:20:17 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write_room - returns 1023
Jul 29 05:20:17 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_interrupt_callback
Jul 29 05:20:17 NICK2 kernel: usb 2-2: edge_interrupt_callback - length = 10, data = 04 00 01 00 00 00 00 00 00 00 
Jul 29 05:20:17 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_interrupt_callback - bytes_avail=4, rxBytesAvail=4, read_in_progress=0
Jul 29 05:20:17 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_interrupt_callback - posting a read
Jul 29 05:20:17 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_interrupt_callback - txcredits for port0 = 1024
Jul 29 05:20:17 NICK2 kernel: drivers/usb/serial/io_edgeport.c: send_more_port_data(0)
Jul 29 05:20:17 NICK2 kernel: drivers/usb/serial/io_edgeport.c: send_more_port_data(0) EXIT - fifo 0, PendingWrite = 0
Jul 29 05:20:17 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_bulk_in_callback
Jul 29 05:20:17 NICK2 kernel: usb 2-2: edge_bulk_in_callback - length = 4, data = 88 0f 88 0f 
Jul 29 05:20:17 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_bulk_in_callback - Received = 4, rxBytesAvail 0
Jul 29 05:20:17 NICK2 kernel: drivers/usb/serial/io_edgeport.c: process_rcvd_data
Jul 29 05:20:17 NICK2 kernel: drivers/usb/serial/io_edgeport.c: process_rcvd_data - Hdr1=88 Hdr2=0F
Jul 29 05:20:17 NICK2 kernel: drivers/usb/serial/io_edgeport.c: process_rcvd_status - port 0
Jul 29 05:20:17 NICK2 kernel: drivers/usb/serial/io_edgeport.c: process_rcvd_status - Port 0 MSR Status = 0f
Jul 29 05:20:17 NICK2 kernel: drivers/usb/serial/io_edgeport.c: handle_new_msr 0f
Jul 29 05:20:17 NICK2 kernel: drivers/usb/serial/io_edgeport.c: process_rcvd_data - Hdr1=88 Hdr2=0F
Jul 29 05:20:17 NICK2 kernel: drivers/usb/serial/io_edgeport.c: process_rcvd_status - port 0
Jul 29 05:20:17 NICK2 kernel: drivers/usb/serial/io_edgeport.c: process_rcvd_status - Port 0 MSR Status = 0f
Jul 29 05:20:17 NICK2 kernel: drivers/usb/serial/io_edgeport.c: handle_new_msr 0f
Jul 29 05:20:17 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_chars_in_buffer
Jul 29 05:20:17 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write_room
Jul 29 05:20:17 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write_room - port 0
Jul 29 05:20:17 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write_room - returns 1024
Jul 29 05:20:18 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_chars_in_buffer
Jul 29 05:20:18 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write_room
Jul 29 05:20:18 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write_room - port 0
Jul 29 05:20:18 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_write_room - returns 1024
Jul 29 05:20:19 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_ioctl - port 0, cmd = 0x540b
Jul 29 05:20:19 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_ioctl - port 0, cmd = 0x5402
Jul 29 05:20:19 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_set_termios - clfag 00000cbd iflag 00000500
Jul 29 05:20:19 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_set_termios - old clfag 000008bb old iflag 00000004
Jul 29 05:20:19 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_set_termios - port 0
Jul 29 05:20:19 NICK2 kernel: drivers/usb/serial/io_edgeport.c: change_port_settings - port 0
Jul 29 05:20:19 NICK2 kernel: drivers/usb/serial/io_edgeport.c: change_port_settings - data bits = 8
Jul 29 05:20:19 NICK2 kernel: drivers/usb/serial/io_edgeport.c: change_port_settings - parity = none
Jul 29 05:20:19 NICK2 kernel: drivers/usb/serial/io_edgeport.c: change_port_settings - stop bits = 1
Jul 29 05:20:19 NICK2 kernel: drivers/usb/serial/io_edgeport.c: change_port_settings - RTS/CTS is disabled
Jul 29 05:20:19 NICK2 kernel: drivers/usb/serial/io_edgeport.c: send_iosp_ext_cmd - 5, 17
Jul 29 05:20:19 NICK2 kernel: edgeport_4 ttyUSB0: write_cmd_usb - length = 3, data = c8 05 11 
Jul 29 05:20:19 NICK2 kernel: drivers/usb/serial/io_edgeport.c: write_cmd_usb - ALLOCATE URB df413a40 (outstanding 1)
Jul 29 05:20:19 NICK2 kernel: drivers/usb/serial/io_edgeport.c: send_iosp_ext_cmd - 6, 19
Jul 29 05:20:19 NICK2 kernel: edgeport_4 ttyUSB0: write_cmd_usb - length = 3, data = c8 06 13 
Jul 29 05:20:19 NICK2 kernel: drivers/usb/serial/io_edgeport.c: write_cmd_usb - ALLOCATE URB d9315780 (outstanding 2)
Jul 29 05:20:19 NICK2 kernel: drivers/usb/serial/io_edgeport.c: change_port_settings - INBOUND XON/XOFF is disabled
Jul 29 05:20:19 NICK2 kernel: drivers/usb/serial/io_edgeport.c: change_port_settings - OUTBOUND XON/XOFF is enabled, XON = 11, XOFF = 13
Jul 29 05:20:19 NICK2 kernel: drivers/usb/serial/io_edgeport.c: send_iosp_ext_cmd - 3, 0
Jul 29 05:20:19 NICK2 kernel: edgeport_4 ttyUSB0: write_cmd_usb - length = 3, data = c8 03 00 
Jul 29 05:20:19 NICK2 kernel: drivers/usb/serial/io_edgeport.c: write_cmd_usb - ALLOCATE URB d9315480 (outstanding 3)
Jul 29 05:20:19 NICK2 kernel: drivers/usb/serial/io_edgeport.c: send_iosp_ext_cmd - 4, 8
Jul 29 05:20:19 NICK2 kernel: edgeport_4 ttyUSB0: write_cmd_usb - length = 3, data = c8 04 08 
Jul 29 05:20:19 NICK2 kernel: drivers/usb/serial/io_edgeport.c: write_cmd_usb - ALLOCATE URB d9315300 (outstanding 4)
Jul 29 05:20:19 NICK2 kernel: drivers/usb/serial/io_edgeport.c: LCR - write to send_cmd_write_uart_register register 0x03
Jul 29 05:20:19 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_bulk_out_cmd_callback
Jul 29 05:20:19 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_bulk_out_cmd_callback - FREE URB df413a40 (outstanding 3)
Jul 29 05:20:19 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_bulk_out_cmd_callback
Jul 29 05:20:19 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_bulk_out_cmd_callback - FREE URB d9315780 (outstanding 2)
Jul 29 05:20:19 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_bulk_out_cmd_callback
Jul 29 05:20:19 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_bulk_out_cmd_callback - FREE URB d9315480 (outstanding 1)
Jul 29 05:20:19 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_bulk_out_cmd_callback
Jul 29 05:20:19 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_bulk_out_cmd_callback - FREE URB d9315300 (outstanding 0)
Jul 29 05:20:19 NICK2 kernel: drivers/usb/serial/io_edgeport.c: SendCmdWriteUartReg - Not writing to MCR Register
Jul 29 05:20:19 NICK2 kernel: drivers/usb/serial/io_edgeport.c: MCR - write to send_cmd_write_uart_register register 0x0b
Jul 29 05:20:19 NICK2 kernel: drivers/usb/serial/io_edgeport.c: SendCmdWriteUartReg - Not writing to MCR Register
Jul 29 05:20:19 NICK2 kernel: drivers/usb/serial/io_edgeport.c: change_port_settings - baud rate = 9600
Jul 29 05:20:19 NICK2 kernel: drivers/usb/serial/io_edgeport.c: SendCmdWriteBaudRate - NOT Setting baud rate for port = 0, baud = 9600
Jul 29 05:20:19 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_ioctl - port 0, cmd = 0x540b
Jul 29 05:20:19 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_close - port 0
Jul 29 05:20:19 NICK2 kernel: drivers/usb/serial/io_edgeport.c: block_until_tx_empty - TX Buffer Empty
Jul 29 05:20:19 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_close - Sending IOSP_CMD_CHASE_PORT
Jul 29 05:20:19 NICK2 kernel: drivers/usb/serial/io_edgeport.c: send_iosp_ext_cmd - 2, 0
Jul 29 05:20:19 NICK2 kernel: edgeport_4 ttyUSB0: write_cmd_usb - length = 3, data = c8 02 00 
Jul 29 05:20:19 NICK2 kernel: drivers/usb/serial/io_edgeport.c: write_cmd_usb - ALLOCATE URB d9315300 (outstanding 1)
Jul 29 05:20:19 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_bulk_out_cmd_callback
Jul 29 05:20:19 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_bulk_out_cmd_callback - FREE URB d9315300 (outstanding 0)
Jul 29 05:20:19 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_interrupt_callback
Jul 29 05:20:19 NICK2 kernel: usb 2-2: edge_interrupt_callback - length = 10, data = 03 00 00 00 00 00 00 00 00 00 
Jul 29 05:20:19 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_interrupt_callback - bytes_avail=3, rxBytesAvail=3, read_in_progress=0
Jul 29 05:20:19 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_interrupt_callback - posting a read
Jul 29 05:20:19 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_bulk_in_callback
Jul 29 05:20:19 NICK2 kernel: usb 2-2: edge_bulk_in_callback - length = 3, data = c8 00 00 
Jul 29 05:20:19 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_bulk_in_callback - Received = 3, rxBytesAvail 0
Jul 29 05:20:19 NICK2 kernel: drivers/usb/serial/io_edgeport.c: process_rcvd_data
Jul 29 05:20:19 NICK2 kernel: drivers/usb/serial/io_edgeport.c: process_rcvd_data - Hdr1=C8 Hdr2=00
Jul 29 05:20:19 NICK2 kernel: drivers/usb/serial/io_edgeport.c: process_rcvd_status - port 0
Jul 29 05:20:19 NICK2 kernel: drivers/usb/serial/io_edgeport.c: process_rcvd_status - Port 0 EXT CHASE_RSP Data = 00
Jul 29 05:20:19 NICK2 kernel: drivers/usb/serial/io_edgeport.c: block_until_chase_response - Got Chase Response
Jul 29 05:20:19 NICK2 kernel: drivers/usb/serial/io_edgeport.c: block_until_chase_response - Got all credits
Jul 29 05:20:19 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_close - Sending IOSP_CMD_CLOSE_PORT
Jul 29 05:20:19 NICK2 kernel: drivers/usb/serial/io_edgeport.c: send_iosp_ext_cmd - 1, 0
Jul 29 05:20:19 NICK2 kernel: edgeport_4 ttyUSB0: write_cmd_usb - length = 3, data = c8 01 00 
Jul 29 05:20:19 NICK2 kernel: drivers/usb/serial/io_edgeport.c: write_cmd_usb - ALLOCATE URB d9315300 (outstanding 1)
Jul 29 05:20:19 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_close exited
Jul 29 05:20:19 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_bulk_out_cmd_callback
Jul 29 05:20:19 NICK2 kernel: drivers/usb/serial/io_edgeport.c: edge_bulk_out_cmd_callback - FREE URB d9315300 (outstanding 0)
*******************************************************************************
*******************************************************************************

On Sat, Jul 28, 2007 at 07:10:54PM -0400, Adam Kropelin wrote:
> Andrew Morton wrote:
> >On Fri, 27 Jul 2007 13:37:08 -0700
> >Nick Pasich <NewsLetters@NickAndBarb.net> wrote:
> >
> >>
> >>Greg/Peter/Al,
> >
> >added linux-usb-devel.
> >
> >>I've been using the edgeport 4 port USB to Serial Converter
> >>to monitor APC Smart UPS's via apcupsd for quite awhile on
> >>various Linux boxes.
> >>
> >>I just upgraded to Kernel Version 2.6.22.1 from 2.6.20.6 on a
> >>couple of systems and both the edgeports stopped communicating.
> >>
> >>I tried applying various patches, "PATCH 026/149" and "PATCH 082/149"
> >>and one by Alan Cox..  but they didn't fix the problem.
> >>
> >>I copied the 2.6.20.6 edgeport module sources to the new
> >>2.6.22.1 tree and everything works again.
> >>
> >>          linux/drivers/usb/serial/io_edgeport.c
> >>          linux/drivers/usb/serial/io_edgeport.h
> >>          linux/drivers/usb/serial/io_edgeport.mod.c
> >>          linux/drivers/usb/serial/io_tables.h
> >
> >Straightforward regression, most serious.  Thanks for reporting it.
> 
> I don't know much of anything about usb-serial, but I'll take a whack at 
> it. Could you enable debug for that driver, launch apcupsd, and report 
> any intersting messages that show up in dmesg? I'd be especially 
> interested in any "Not setting..." or "Not writing..." messages, because 
> some critical-looking code for baud rate setting and similar became 
> conditional in 2.6.22.1 whereas it was always executed before. Apcupsd 
> is going to be rather unhappy if the baud rate doesn't change when it 
> asks. The debug should show if the these operations are being ignored on 
> your hw.
> 
> --Adam
> 

