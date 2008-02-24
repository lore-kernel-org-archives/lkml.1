Return-Path: <linux-kernel-owner+w=401wt.eu-S1755796AbYBXWH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796AbYBXWH4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 17:07:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753677AbYBXWHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 17:07:46 -0500
Received: from wr-out-0506.google.com ([64.233.184.228]:22715 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbYBXWHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 17:07:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=tAORiWKpbqaKCy7jhBrrq/m356Kn5o1YOG4+1oFX+S57T4TlemOSsuhu9d716DOSihz+fmZwZe//g3VkcSajJl44eXIK7IhNeXtzMfe4U/q+Q9YD3vwTNt06A+bbUDZ2pfKsQTeRbs70ftwXMHQ/pl5d8SkrMYjngf4BEMnwyTQ=
Message-ID: <c4e36d110802241407q4808e3f8n318723a70696fd0d@mail.gmail.com>
Date: Sun, 24 Feb 2008 23:07:44 +0100
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: latest commit on thinkpad_acpi.c 6c231bd5eb07 shows warning
Cc: hmh@hmh.eng.br, len.brown@intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Commit 6c231bd5eb07ce546517019f334652b9ecfc329a
generate this warning:

drivers/misc/thinkpad_acpi.c: In function 'tpacpi_input_send_tabletsw':
include/linux/input.h:1290: warning: 'state' is used uninitialized in
this function
drivers/misc/thinkpad_acpi.c:1191: note: 'state' was declared here
drivers/misc/thinkpad_acpi.c: In function 'hotkey_tablet_mode_show':
drivers/misc/thinkpad_acpi.c:1723: warning: 's' is used uninitialized
in this function

I assume typo  here thinkpad_acpi.c:10724 hotkey_get_tablet_mode
where status should be maybe 's' and local 's' shouldn't be defined at
all -  just guess?

Zdenek
