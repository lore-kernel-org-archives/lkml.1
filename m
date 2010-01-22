Return-Path: <linux-kernel-owner+w=401wt.eu-S932166Ab0AVB4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166Ab0AVB4S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 20:56:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754315Ab0AVB4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 20:56:17 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:54013 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150Ab0AVB4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 20:56:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=OFjUfpcWJlkXV4qtvzJeMe77qjyR/q/+8oGY057YVydFp7GxT3sJlqJKfQ15Mf3ZY9
         nUtuz3QRleuXE11zdv6ltSjshrF2uB9OVqfeEnFJ+rA9Z8bmM+BZF8t5yaQztw7t9Jrl
         p5cQe69w05ykA1Lo2yapBmR6HOwF7dVdZcQRw=
Message-ID: <4B5905B3.2010309@gmail.com>
Date: Fri, 22 Jan 2010 09:56:03 +0800
From: "sxzzsf(Shengfeng Zhou)" <sxzzsf@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; zh-CN; rv:1.9.1.7) Gecko/20100121 Thunderbird/3.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.32.4 PL2303 USB-serial can not connect to another serial port
Content-Type: text/plain; charset=WINDOWS-936; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I connect PL2303 USB-serial to another pc's serial port using 
minicom, the USB-serial always failes to communicate. Here is the kernel 
message:

[ 5263.206082] usb 3-1: new full speed USB device using uhci_hcd and 
address 18
[ 5263.346493] usb 3-1: configuration #1 chosen from 1 choice
[ 5263.350744] pl2303 3-1:1.0: pl2303 converter detected
[ 5263.350757] drivers/usb/serial/pl2303.c: device type: 1
[ 5263.352319] drivers/usb/serial/pl2303.c: 0xc0:0x1:0x8484:0x0  1 - 0
[ 5263.353317] drivers/usb/serial/pl2303.c: 0x40:0x1:0x404:0x0  0
[ 5263.354317] drivers/usb/serial/pl2303.c: 0xc0:0x1:0x8484:0x0  1 - 0
[ 5263.355528] drivers/usb/serial/pl2303.c: 0xc0:0x1:0x8383:0x0  1 - 0
[ 5263.357775] drivers/usb/serial/pl2303.c: 0xc0:0x1:0x8484:0x0  1 - 0
[ 5263.358319] drivers/usb/serial/pl2303.c: 0x40:0x1:0x404:0x1  0
[ 5263.359318] drivers/usb/serial/pl2303.c: 0xc0:0x1:0x8484:0x0  1 - 0
[ 5263.360318] drivers/usb/serial/pl2303.c: 0xc0:0x1:0x8383:0x0  1 - 0
[ 5263.361331] drivers/usb/serial/pl2303.c: 0x40:0x1:0x0:0x1  0
[ 5263.362329] drivers/usb/serial/pl2303.c: 0x40:0x1:0x1:0x0  0
[ 5263.363330] drivers/usb/serial/pl2303.c: 0x40:0x1:0x2:0x24  0
[ 5263.363422] usb 3-1: pl2303 converter now attached to ttyUSB0
[ 5271.783112] drivers/usb/serial/pl2303.c: pl2303_open -  port 0
[ 5271.785731] drivers/usb/serial/pl2303.c: pl2303_set_termios -  port 0
[ 5271.786733] drivers/usb/serial/pl2303.c: 0xa1:0x21:0:0  7 - 0 0 0 0 0 0 0
[ 5271.786737] drivers/usb/serial/pl2303.c: pl2303_set_termios - data 
bits = 8
[ 5271.786740] drivers/usb/serial/pl2303.c: pl2303_set_termios - baud 
requested = 0
[ 5271.786743] drivers/usb/serial/pl2303.c: pl2303_set_termios - stop 
bits = 1
[ 5271.786746] drivers/usb/serial/pl2303.c: pl2303_set_termios - parity 
= none
[ 5271.789968] drivers/usb/serial/pl2303.c: 0x21:0x20:0:0  7
[ 5271.790739] drivers/usb/serial/pl2303.c: 0xa1:0x21:0:0  7 - 0 0 0 0 0 0 8
[ 5271.791735] drivers/usb/serial/pl2303.c: 0x40:0x1:0x0:0x0  0
[ 5271.791740] drivers/usb/serial/pl2303.c: pl2303_open - submitting 
read urb
[ 5271.791746] drivers/usb/serial/pl2303.c: pl2303_open - submitting 
interrupt urb
[ 5271.791776] drivers/usb/serial/pl2303.c: pl2303_ioctl (0) cmd = 0x5401
[ 5271.791780] drivers/usb/serial/pl2303.c: pl2303_ioctl not supported = 
0x5401
[ 5271.791790] drivers/usb/serial/pl2303.c: pl2303_tiocmget (0)
[ 5271.791794] drivers/usb/serial/pl2303.c: pl2303_tiocmget - result = 0
[ 5271.791802] drivers/usb/serial/pl2303.c: pl2303_ioctl (0) cmd = 0x5401
[ 5271.791805] drivers/usb/serial/pl2303.c: pl2303_ioctl not supported = 
0x5401
[ 5271.791814] drivers/usb/serial/pl2303.c: pl2303_ioctl (0) cmd = 0x5402
[ 5271.791817] drivers/usb/serial/pl2303.c: pl2303_ioctl not supported = 
0x5402
[ 5271.791823] drivers/usb/serial/pl2303.c: pl2303_set_termios -  port 0
[ 5271.792734] drivers/usb/serial/pl2303.c: 0xa1:0x21:0:0  7 - 0 0 0 0 0 0 8
[ 5271.792739] drivers/usb/serial/pl2303.c: pl2303_set_termios - data 
bits = 8
[ 5271.792743] drivers/usb/serial/pl2303.c: pl2303_set_termios - baud 
requested = 38400
[ 5271.792747] drivers/usb/serial/pl2303.c: pl2303_set_termios - baud 
set = 38400
[ 5271.792751] drivers/usb/serial/pl2303.c: pl2303_set_termios - stop 
bits = 1
[ 5271.792754] drivers/usb/serial/pl2303.c: pl2303_set_termios - parity 
= none
[ 5271.793723] drivers/usb/serial/pl2303.c: pl2303_read_int_callback (0)
[ 5271.793729] pl2303 ttyUSB0: pl2303_read_int_callback - length = 10, 
data = a1 20 00 00 00 00 02 00 00 00
[ 5271.793754] drivers/usb/serial/pl2303.c: 0x21:0x20:0:0  7
[ 5271.794734] drivers/usb/serial/pl2303.c: set_control_lines - value = 
3, retval = 0
[ 5271.795724] drivers/usb/serial/pl2303.c: pl2303_read_int_callback (0)
[ 5271.795729] pl2303 ttyUSB0: pl2303_read_int_callback - length = 10, 
data = a1 20 00 00 00 00 02 00 08 00
[ 5271.795755] drivers/usb/serial/pl2303.c: 0xa1:0x21:0:0  7 - 0 96 0 0 
0 0 8
[ 5271.796733] drivers/usb/serial/pl2303.c: 0x40:0x1:0x0:0x0  0
[ 5271.796740] drivers/usb/serial/pl2303.c: pl2303_tiocmget (0)
[ 5271.796744] drivers/usb/serial/pl2303.c: pl2303_tiocmget - result = 86
[ 5271.797734] drivers/usb/serial/pl2303.c: set_control_lines - value = 
3, retval = 0
[ 5271.797741] drivers/usb/serial/pl2303.c: pl2303_ioctl (0) cmd = 0x5401
[ 5271.797744] drivers/usb/serial/pl2303.c: pl2303_ioctl not supported = 
0x5401
[ 5271.797749] drivers/usb/serial/pl2303.c: pl2303_ioctl (0) cmd = 0x5402
[ 5271.797753] drivers/usb/serial/pl2303.c: pl2303_ioctl not supported = 
0x5402
[ 5271.797758] drivers/usb/serial/pl2303.c: pl2303_set_termios -  port 0
[ 5271.797768] drivers/usb/serial/pl2303.c: pl2303_ioctl (0) cmd = 0x5401
[ 5271.797772] drivers/usb/serial/pl2303.c: pl2303_ioctl not supported = 
0x5401
[ 5271.797776] drivers/usb/serial/pl2303.c: pl2303_ioctl (0) cmd = 0x5402
[ 5271.797780] drivers/usb/serial/pl2303.c: pl2303_ioctl not supported = 
0x5402
[ 5271.797784] drivers/usb/serial/pl2303.c: pl2303_set_termios -  port 0
[ 5271.797789] drivers/usb/serial/pl2303.c: pl2303_ioctl (0) cmd = 0x5401
[ 5271.797793] drivers/usb/serial/pl2303.c: pl2303_ioctl not supported = 
0x5401
[ 5271.797797] drivers/usb/serial/pl2303.c: pl2303_ioctl (0) cmd = 0x5402
[ 5271.797801] drivers/usb/serial/pl2303.c: pl2303_ioctl not supported = 
0x5402
[ 5271.797805] drivers/usb/serial/pl2303.c: pl2303_set_termios -  port 0
[ 5271.797810] drivers/usb/serial/pl2303.c: pl2303_ioctl (0) cmd = 0x540b
[ 5271.797814] drivers/usb/serial/pl2303.c: pl2303_ioctl not supported = 
0x540b
[ 5271.809718] drivers/usb/serial/pl2303.c: pl2303_ioctl (0) cmd = 0x5401
[ 5271.809729] drivers/usb/serial/pl2303.c: pl2303_ioctl not supported = 
0x5401
[ 5271.809740] drivers/usb/serial/pl2303.c: pl2303_ioctl (0) cmd = 0x5401
[ 5271.809746] drivers/usb/serial/pl2303.c: pl2303_ioctl not supported = 
0x5401
[ 5271.809754] drivers/usb/serial/pl2303.c: pl2303_ioctl (0) cmd = 0x5402
[ 5271.809760] drivers/usb/serial/pl2303.c: pl2303_ioctl not supported = 
0x5402
[ 5271.809771] drivers/usb/serial/pl2303.c: pl2303_set_termios -  port 0
[ 5271.812539] drivers/usb/serial/pl2303.c: 0xa1:0x21:0:0  7 - 0 96 0 0 
0 0 8
[ 5271.812545] drivers/usb/serial/pl2303.c: pl2303_set_termios - data 
bits = 8
[ 5271.812548] drivers/usb/serial/pl2303.c: pl2303_set_termios - baud 
requested = 0
[ 5271.812552] drivers/usb/serial/pl2303.c: pl2303_set_termios - stop 
bits = 1
[ 5271.812554] drivers/usb/serial/pl2303.c: pl2303_set_termios - parity 
= none
[ 5271.812727] drivers/usb/serial/pl2303.c: 0x21:0x20:0:0  7
[ 5271.813733] drivers/usb/serial/pl2303.c: set_control_lines - value = 
0, retval = 0
[ 5271.814732] drivers/usb/serial/pl2303.c: 0xa1:0x21:0:0  7 - 0 96 0 0 
0 0 8
[ 5271.815731] drivers/usb/serial/pl2303.c: 0x40:0x1:0x0:0x0  0
[ 5272.815844] drivers/usb/serial/pl2303.c: pl2303_ioctl (0) cmd = 0x5402
[ 5272.815853] drivers/usb/serial/pl2303.c: pl2303_ioctl not supported = 
0x5402
[ 5272.815864] drivers/usb/serial/pl2303.c: pl2303_set_termios -  port 0
[ 5272.817801] drivers/usb/serial/pl2303.c: 0xa1:0x21:0:0  7 - 0 96 0 0 
0 0 8
[ 5272.817809] drivers/usb/serial/pl2303.c: pl2303_set_termios - data 
bits = 8
[ 5272.817816] drivers/usb/serial/pl2303.c: pl2303_set_termios - baud 
requested = 38400
[ 5272.817823] drivers/usb/serial/pl2303.c: pl2303_set_termios - baud 
set = 38400
[ 5272.817829] drivers/usb/serial/pl2303.c: pl2303_set_termios - stop 
bits = 1
[ 5272.817835] drivers/usb/serial/pl2303.c: pl2303_set_termios - parity 
= none
[ 5272.818792] drivers/usb/serial/pl2303.c: 0x21:0x20:0:0  7
[ 5272.819790] drivers/usb/serial/pl2303.c: set_control_lines - value = 
3, retval = 0
[ 5272.820775] drivers/usb/serial/pl2303.c: pl2303_read_int_callback (0)
[ 5272.820784] pl2303 ttyUSB0: pl2303_read_int_callback - length = 10, 
data = a1 20 00 00 00 00 02 00 08 00
[ 5272.820822] drivers/usb/serial/pl2303.c: 0xa1:0x21:0:0  7 - 0 96 0 0 
0 0 8
[ 5272.821775] drivers/usb/serial/pl2303.c: 0x40:0x1:0x0:0x0  0
[ 5273.821933] drivers/usb/serial/pl2303.c: pl2303_write - port 0, 1 bytes
[ 5273.821943] drivers/usb/serial/pl2303.c: pl2303_send - port 0
[ 5273.821950] pl2303 ttyUSB0: pl2303_send - length = 1, data = 0d
[ 5273.823828] drivers/usb/serial/pl2303.c: pl2303_write_bulk_callback - 
port 0
[ 5273.823835] drivers/usb/serial/pl2303.c: pl2303_send - port 0
[ 5274.822070] drivers/usb/serial/pl2303.c: pl2303_write - port 0, 1 bytes
[ 5274.822080] drivers/usb/serial/pl2303.c: pl2303_send - port 0
[ 5274.822087] pl2303 ttyUSB0: pl2303_send - length = 1, data = 41
[ 5274.822108] drivers/usb/serial/pl2303.c: pl2303_write - port 0, 1 bytes
[ 5274.822114] drivers/usb/serial/pl2303.c: pl2303_send - port 0
...repeated...
[ 5274.822496] drivers/usb/serial/pl2303.c: pl2303_write - port 0, 1 bytes
[ 5274.822502] drivers/usb/serial/pl2303.c: pl2303_send - port 0
[ 5274.822509] drivers/usb/serial/pl2303.c: pl2303_write - port 0, 1 bytes
[ 5274.822515] drivers/usb/serial/pl2303.c: pl2303_send - port 0
[ 5274.822523] drivers/usb/serial/pl2303.c: pl2303_write - port 0, 1 bytes
[ 5274.822529] drivers/usb/serial/pl2303.c: pl2303_send - port 0
[ 5274.822935] drivers/usb/serial/pl2303.c: pl2303_tiocmget (0)
[ 5274.822942] drivers/usb/serial/pl2303.c: pl2303_tiocmget - result = 86
[ 5274.822951] drivers/usb/serial/pl2303.c: pl2303_ioctl (0) cmd = 0x5401
[ 5274.822957] drivers/usb/serial/pl2303.c: pl2303_ioctl not supported = 
0x5401
[ 5274.822982] drivers/usb/serial/pl2303.c: pl2303_chars_in_buffer - port 0
[ 5274.822988] drivers/usb/serial/pl2303.c: pl2303_chars_in_buffer - 
returns 32
[ 5274.822994] drivers/usb/serial/pl2303.c: pl2303_write_room - port 0
[ 5274.823001] drivers/usb/serial/pl2303.c: pl2303_write_room - returns 991
[ 5274.823862] drivers/usb/serial/pl2303.c: pl2303_write_bulk_callback - 
port 0
[ 5274.823869] drivers/usb/serial/pl2303.c: pl2303_send - port 0
[ 5274.823875] pl2303 ttyUSB0: pl2303_send - length = 32, data = 54 20 
53 37 3d 34 35 20 53 30 3d 30 20 4c 31 20 56 31 20 58 34 20 26 63 31 20 
45 31 20 51 30 0d
[ 5274.824860] drivers/usb/serial/pl2303.c: pl2303_write_bulk_callback - 
port 0
[ 5274.824868] drivers/usb/serial/pl2303.c: pl2303_send - port 0
[ 5275.824051] drivers/usb/serial/pl2303.c: pl2303_chars_in_buffer - port 0
[ 5275.824061] drivers/usb/serial/pl2303.c: pl2303_chars_in_buffer - 
returns 0
[ 5275.824068] drivers/usb/serial/pl2303.c: pl2303_write_room - port 0
[ 5275.824074] drivers/usb/serial/pl2303.c: pl2303_write_room - returns 1023
[ 5275.824089] drivers/usb/serial/pl2303.c: pl2303_tiocmget (0)
[ 5275.824096] drivers/usb/serial/pl2303.c: pl2303_tiocmget - result = 86
[ 5275.824105] drivers/usb/serial/pl2303.c: pl2303_ioctl (0) cmd = 0x5401
[ 5275.824112] drivers/usb/serial/pl2303.c: pl2303_ioctl not supported = 
0x5401
[ 5275.824127] drivers/usb/serial/pl2303.c: pl2303_chars_in_buffer - port 0
[ 5275.824133] drivers/usb/serial/pl2303.c: pl2303_chars_in_buffer - 
returns 0
[ 5275.824139] drivers/usb/serial/pl2303.c: pl2303_write_room - port 0
[ 5275.824145] drivers/usb/serial/pl2303.c: pl2303_write_room - returns 1023
[ 5276.824223] drivers/usb/serial/pl2303.c: pl2303_chars_in_buffer - port 0
[ 5276.824233] drivers/usb/serial/pl2303.c: pl2303_chars_in_buffer - 
returns 0
[ 5276.824240] drivers/usb/serial/pl2303.c: pl2303_write_room - port 0
[ 5276.824246] drivers/usb/serial/pl2303.c: pl2303_write_room - returns 1023
[ 5276.824261] drivers/usb/serial/pl2303.c: pl2303_tiocmget (0)
[ 5276.824267] drivers/usb/serial/pl2303.c: pl2303_tiocmget - result = 86
[ 5276.824277] drivers/usb/serial/pl2303.c: pl2303_ioctl (0) cmd = 0x5401
[ 5276.824283] drivers/usb/serial/pl2303.c: pl2303_ioctl not supported = 
0x5401
[ 5276.824298] drivers/usb/serial/pl2303.c: pl2303_chars_in_buffer - port 0
[ 5276.824305] drivers/usb/serial/pl2303.c: pl2303_chars_in_buffer - 
returns 0
[ 5276.824311] drivers/usb/serial/pl2303.c: pl2303_write_room - port 0
[ 5276.824317] drivers/usb/serial/pl2303.c: pl2303_write_room - returns 1023
[ 5277.825368] drivers/usb/serial/pl2303.c: pl2303_chars_in_buffer - port 0
[ 5277.825378] drivers/usb/serial/pl2303.c: pl2303_chars_in_buffer - 
returns 0
[ 5277.825385] drivers/usb/serial/pl2303.c: pl2303_write_room - port 0
[ 5277.825391] drivers/usb/serial/pl2303.c: pl2303_write_room - returns 1023
[ 5277.825406] drivers/usb/serial/pl2303.c: pl2303_tiocmget (0)
[ 5277.825412] drivers/usb/serial/pl2303.c: pl2303_tiocmget - result = 86
[ 5277.825422] drivers/usb/serial/pl2303.c: pl2303_ioctl (0) cmd = 0x5401
[ 5277.825428] drivers/usb/serial/pl2303.c: pl2303_ioctl not supported = 
0x5401
[ 5277.825444] drivers/usb/serial/pl2303.c: pl2303_chars_in_buffer - port 0
[ 5277.825450] drivers/usb/serial/pl2303.c: pl2303_chars_in_buffer - 
returns 0
[ 5277.825456] drivers/usb/serial/pl2303.c: pl2303_write_room - port 0
[ 5277.825462] drivers/usb/serial/pl2303.c: pl2303_write_room - returns 1023
[ 5278.769054] drivers/usb/serial/pl2303.c: pl2303_read_bulk_callback - 
port 0
[ 5278.769060] drivers/usb/serial/pl2303.c: pl2303_read_bulk_callback - 
urb status = -75
[ 5278.769063] drivers/usb/serial/pl2303.c: pl2303_read_bulk_callback - 
unable to handle the error, exiting.
[ 5278.771048] drivers/usb/serial/pl2303.c: pl2303_read_int_callback (0)
[ 5278.771053] drivers/usb/serial/pl2303.c: pl2303_read_int_callback - 
nonzero urb status received: -84
[ 5278.775055] drivers/usb/serial/pl2303.c: pl2303_read_int_callback (0)
[ 5278.775060] drivers/usb/serial/pl2303.c: pl2303_read_int_callback - 
nonzero urb status received: -84
[ 5278.779056] drivers/usb/serial/pl2303.c: pl2303_read_int_callback (0)
...repeated...
[ 5278.819072] drivers/usb/serial/pl2303.c: pl2303_read_int_callback - 
nonzero urb status received: -84
[ 5278.823064] drivers/usb/serial/pl2303.c: pl2303_read_int_callback (0)
[ 5278.823072] drivers/usb/serial/pl2303.c: pl2303_read_int_callback - 
nonzero urb status received: -84
[ 5278.826514] drivers/usb/serial/pl2303.c: pl2303_chars_in_buffer - port 0
[ 5278.826521] drivers/usb/serial/pl2303.c: pl2303_chars_in_buffer - 
returns 0
[ 5278.826528] drivers/usb/serial/pl2303.c: pl2303_write_room - port 0
[ 5278.826534] drivers/usb/serial/pl2303.c: pl2303_write_room - returns 1023
[ 5278.826549] drivers/usb/serial/pl2303.c: pl2303_tiocmget (0)
[ 5278.826555] drivers/usb/serial/pl2303.c: pl2303_tiocmget - result = 86
[ 5278.826565] drivers/usb/serial/pl2303.c: pl2303_ioctl (0) cmd = 0x5401
[ 5278.826572] drivers/usb/serial/pl2303.c: pl2303_ioctl not supported = 
0x5401
[ 5278.826587] drivers/usb/serial/pl2303.c: pl2303_chars_in_buffer - port 0
[ 5278.826593] drivers/usb/serial/pl2303.c: pl2303_chars_in_buffer - 
returns 0
[ 5278.826599] drivers/usb/serial/pl2303.c: pl2303_write_room - port 0
[ 5278.826605] drivers/usb/serial/pl2303.c: pl2303_write_room - returns 1023
[ 5278.827049] drivers/usb/serial/pl2303.c: pl2303_read_int_callback (0)
[ 5278.827057] drivers/usb/serial/pl2303.c: pl2303_read_int_callback - 
nonzero urb status received: -84
[ 5278.831065] drivers/usb/serial/pl2303.c: pl2303_read_int_callback (0)
[ 5278.831074] drivers/usb/serial/pl2303.c: pl2303_read_int_callback - 
nonzero urb status received: -84
[ 5278.831065] drivers/usb/serial/pl2303.c: pl2303_read_int_callback (0)
...repeated...
[ 5278.995081] drivers/usb/serial/pl2303.c: pl2303_read_int_callback - 
nonzero urb status received: -84
[ 5278.999073] drivers/usb/serial/pl2303.c: pl2303_read_int_callback (0)
[ 5278.999082] drivers/usb/serial/pl2303.c: pl2303_read_int_callback - 
nonzero urb status received: -84
[ 5279.000088] hub 3-0:1.0: port 1 disabled by hub (EMI?), re-enabling...
[ 5279.000096] usb 3-1: USB disconnect, address 18
[ 5279.002070] drivers/usb/serial/pl2303.c: pl2303_read_int_callback (0)
[ 5279.002079] drivers/usb/serial/pl2303.c: pl2303_read_int_callback - 
urb shutting down with status: -108
[ 5279.002217] drivers/usb/serial/pl2303.c: pl2303_close - port 0
[ 5279.002224] drivers/usb/serial/pl2303.c: pl2303_close - shutting down 
urbs
[ 5279.002352] pl2303 ttyUSB0: pl2303 converter now disconnected from 
ttyUSB0
[ 5279.002376] pl2303 3-1:1.0: device disconnected
[ 5279.102054] drivers/usb/serial/pl2303.c: set_control_lines - value = 
0, retval = -19
[ 5279.261027] usb 3-1: new full speed USB device using uhci_hcd and 
address 19
[ 5279.399266] usb 3-1: configuration #1 chosen from 1 choice
[ 5279.403472] pl2303 3-1:1.0: pl2303 converter detected
[ 5279.403485] drivers/usb/serial/pl2303.c: device type: 1
[ 5279.405093] drivers/usb/serial/pl2303.c: 0xc0:0x1:0x8484:0x0  1 - 0
[ 5279.406098] drivers/usb/serial/pl2303.c: 0x40:0x1:0x404:0x0  0
[ 5279.407158] drivers/usb/serial/pl2303.c: 0xc0:0x1:0x8484:0x0  1 - 0
[ 5279.408159] drivers/usb/serial/pl2303.c: 0xc0:0x1:0x8383:0x0  1 - 0
[ 5279.409159] drivers/usb/serial/pl2303.c: 0xc0:0x1:0x8484:0x0  1 - 0
[ 5279.410111] drivers/usb/serial/pl2303.c: 0x40:0x1:0x404:0x1  0
[ 5279.411082] drivers/usb/serial/pl2303.c: 0xc0:0x1:0x8484:0x0  1 - 0
[ 5279.413092] drivers/usb/serial/pl2303.c: 0xc0:0x1:0x8383:0x0  1 - 0
[ 5279.414137] drivers/usb/serial/pl2303.c: 0x40:0x1:0x0:0x1  0
[ 5279.415082] drivers/usb/serial/pl2303.c: 0x40:0x1:0x1:0x0  0
[ 5279.416287] drivers/usb/serial/pl2303.c: 0x40:0x1:0x2:0x24  0
[ 5279.416383] usb 3-1: pl2303 converter now attached to ttyUSB1
