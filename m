Return-Path: <linux-kernel-owner+w=401wt.eu-S932486AbXCYI2C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932486AbXCYI2C (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 04:28:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933215AbXCYI2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 04:28:01 -0400
Received: from max.feld.cvut.cz ([147.32.192.36]:55366 "EHLO max.feld.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932486AbXCYI17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 04:27:59 -0400
From: CIJOML <cijoml@volny.cz>
To: linux-kernel@vger.kernel.org
Subject: HID OOPS running hid2hci on logitech diNovo dongle
Date: Sun, 25 Mar 2007 10:27:41 +0200
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703251027.41441.cijoml@volny.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi hid guys,

in combination of kernel 2.6.20-mh1 and hid2hci from bluez-utils-3.9
I am getting following OOPS:

BUG: at drivers/hid/hid-core.c:785 implement()
 [<c027a9c3>] hid_output_report+0x213/0x2be
 [<fcaf73fb>] hid_submit_ctrl+0x52/0x1bc [usbhid]
 [<fcaf76b9>] usbhid_submit_report+0x154/0x187 [usbhid]
 [<fcaf7970>] usbhid_init_reports+0x60/0xbb [usbhid]
 [<fcaf917d>] hiddev_ioctl+0x361/0x8e7 [usbhid]
 [<c01b4dd1>] avc_has_perm+0x4e/0x58
 [<c01b5595>] inode_has_perm+0x5b/0x63
 [<c0148652>] __handle_mm_fault+0x2c3/0x7b1
 [<c01b5626>] file_has_perm+0x89/0x91
 [<c0161158>] do_ioctl+0x4c/0x62
 [<c01613aa>] vfs_ioctl+0x23c/0x24f
 [<c0161409>] sys_ioctl+0x4c/0x67
 [<c0102cc8>] syscall_call+0x7/0xb
 [<c02d0033>] __sched_text_start+0x43/0x546
 =======================
BUG: at drivers/hid/hid-core.c:785 implement()
 [<c027a9c3>] hid_output_report+0x213/0x2be
 [<fcaf73fb>] hid_submit_ctrl+0x52/0x1bc [usbhid]
 [<fcaf76b9>] usbhid_submit_report+0x154/0x187 [usbhid]
 [<fcaf7970>] usbhid_init_reports+0x60/0xbb [usbhid]
 [<fcaf917d>] hiddev_ioctl+0x361/0x8e7 [usbhid]
 [<c01b4dd1>] avc_has_perm+0x4e/0x58
 [<c01b5595>] inode_has_perm+0x5b/0x63
 [<c0148652>] __handle_mm_fault+0x2c3/0x7b1
 [<c01b5626>] file_has_perm+0x89/0x91
 [<c0161158>] do_ioctl+0x4c/0x62
 [<c01613aa>] vfs_ioctl+0x23c/0x24f
 [<c0161409>] sys_ioctl+0x4c/0x67
 [<c0102cc8>] syscall_call+0x7/0xb
 [<c02d0033>] __sched_text_start+0x43/0x546
 =======================
BUG: at drivers/hid/hid-core.c:785 implement()
 [<c027a9c3>] hid_output_report+0x213/0x2be
 [<fcaf73fb>] hid_submit_ctrl+0x52/0x1bc [usbhid]
 [<fcaf76b9>] usbhid_submit_report+0x154/0x187 [usbhid]
 [<fcaf7970>] usbhid_init_reports+0x60/0xbb [usbhid]
 [<fcaf917d>] hiddev_ioctl+0x361/0x8e7 [usbhid]
 [<c01b4dd1>] avc_has_perm+0x4e/0x58
 [<c01b5595>] inode_has_perm+0x5b/0x63
 [<c0148652>] __handle_mm_fault+0x2c3/0x7b1
 [<c01b5626>] file_has_perm+0x89/0x91
 [<c0161158>] do_ioctl+0x4c/0x62
 [<c01613aa>] vfs_ioctl+0x23c/0x24f
 [<c0161409>] sys_ioctl+0x4c/0x67
 [<c0102cc8>] syscall_call+0x7/0xb
 [<c02d0033>] __sched_text_start+0x43/0x546
 =======================
BUG: at drivers/hid/hid-core.c:785 implement()
 [<c027a9c3>] hid_output_report+0x213/0x2be
 [<fcaf73fb>] hid_submit_ctrl+0x52/0x1bc [usbhid]
 [<fcaf76b9>] usbhid_submit_report+0x154/0x187 [usbhid]
 [<fcaf917d>] hiddev_ioctl+0x361/0x8e7 [usbhid]
 [<c01b4dd1>] avc_has_perm+0x4e/0x58
 [<c01b5595>] inode_has_perm+0x5b/0x63
 [<c0148652>] __handle_mm_fault+0x2c3/0x7b1
 [<c01b5626>] file_has_perm+0x89/0x91
 [<c0161158>] do_ioctl+0x4c/0x62
 [<c01613aa>] vfs_ioctl+0x23c/0x24f
 [<c0161409>] sys_ioctl+0x4c/0x67
 [<c0102cc8>] syscall_call+0x7/0xb
 [<c02d0033>] __sched_text_start+0x43/0x546
 =======================
BUG: at drivers/hid/hid-core.c:785 implement()
 [<c027a9c3>] hid_output_report+0x213/0x2be
 [<fcaf73fb>] hid_submit_ctrl+0x52/0x1bc [usbhid]
 [<fcaf76b9>] usbhid_submit_report+0x154/0x187 [usbhid]
 [<fcaf917d>] hiddev_ioctl+0x361/0x8e7 [usbhid]
 [<c01b4dd1>] avc_has_perm+0x4e/0x58
 [<c01b5595>] inode_has_perm+0x5b/0x63
 [<c0148652>] __handle_mm_fault+0x2c3/0x7b1
 [<c01b5626>] file_has_perm+0x89/0x91
 [<c0161158>] do_ioctl+0x4c/0x62
 [<c01613aa>] vfs_ioctl+0x23c/0x24f
 [<c0161409>] sys_ioctl+0x4c/0x67
 [<c0102cc8>] syscall_call+0x7/0xb
 [<c02d0033>] __sched_text_start+0x43/0x546
 =======================
BUG: at drivers/hid/hid-core.c:785 implement()
 [<c027a9c3>] hid_output_report+0x213/0x2be
 [<c011bfb6>] irq_exit+0x25/0x30
 [<c0105190>] do_IRQ+0x87/0x9b
 [<fcaf73fb>] hid_submit_ctrl+0x52/0x1bc [usbhid]
 [<fcaf76b9>] usbhid_submit_report+0x154/0x187 [usbhid]
 [<c0127f9f>] autoremove_wake_function+0x0/0x35
 [<fcaf917d>] hiddev_ioctl+0x361/0x8e7 [usbhid]
 [<c01b4dd1>] avc_has_perm+0x4e/0x58
 [<c01b5595>] inode_has_perm+0x5b/0x63
 [<c0148652>] __handle_mm_fault+0x2c3/0x7b1
 [<c01b5626>] file_has_perm+0x89/0x91
 [<c0161158>] do_ioctl+0x4c/0x62
 [<c01613aa>] vfs_ioctl+0x23c/0x24f
 [<c0161409>] sys_ioctl+0x4c/0x67
 [<c0102cc8>] syscall_call+0x7/0xb
 [<c02d0033>] __sched_text_start+0x43/0x546
 =======================
BUG: at drivers/hid/hid-core.c:785 implement()
 [<c027a9c3>] hid_output_report+0x213/0x2be
 [<c011bfb6>] irq_exit+0x25/0x30
 [<c0105190>] do_IRQ+0x87/0x9b
 [<fcaf73fb>] hid_submit_ctrl+0x52/0x1bc [usbhid]
 [<fcaf76b9>] usbhid_submit_report+0x154/0x187 [usbhid]
 [<c0127f9f>] autoremove_wake_function+0x0/0x35
 [<fcaf917d>] hiddev_ioctl+0x361/0x8e7 [usbhid]
 [<c01b4dd1>] avc_has_perm+0x4e/0x58
 [<c01b5595>] inode_has_perm+0x5b/0x63
 [<c0148652>] __handle_mm_fault+0x2c3/0x7b1
 [<c01b5626>] file_has_perm+0x89/0x91
 [<c0161158>] do_ioctl+0x4c/0x62
 [<c01613aa>] vfs_ioctl+0x23c/0x24f
 [<c0161409>] sys_ioctl+0x4c/0x67
 [<c0102cc8>] syscall_call+0x7/0xb
 [<c02d0033>] __sched_text_start+0x43/0x546
 =======================
BUG: at drivers/hid/hid-core.c:785 implement()
 [<c027a9c3>] hid_output_report+0x213/0x2be
 [<c011bfb6>] irq_exit+0x25/0x30
 [<c0105190>] do_IRQ+0x87/0x9b
 [<fcaf73fb>] hid_submit_ctrl+0x52/0x1bc [usbhid]
 [<fcaf76b9>] usbhid_submit_report+0x154/0x187 [usbhid]
 [<c0127f9f>] autoremove_wake_function+0x0/0x35
 [<fcaf917d>] hiddev_ioctl+0x361/0x8e7 [usbhid]
 [<c01b4dd1>] avc_has_perm+0x4e/0x58
 [<c01b5595>] inode_has_perm+0x5b/0x63
 [<c0148652>] __handle_mm_fault+0x2c3/0x7b1
 [<c01b5626>] file_has_perm+0x89/0x91
 [<c0161158>] do_ioctl+0x4c/0x62
 [<c01613aa>] vfs_ioctl+0x23c/0x24f
 [<c0161409>] sys_ioctl+0x4c/0x67
 [<c0102cc8>] syscall_call+0x7/0xb
 [<c02d0033>] __sched_text_start+0x43/0x546
 =======================
usb 7-1.1: new full speed USB device using ohci_hcd and address 5
usb 7-1.1: configuration #1 chosen from 1 choice

Best regards

Michal
