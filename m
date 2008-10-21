Return-Path: <linux-kernel-owner+w=401wt.eu-S1751876AbYJUROb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876AbYJUROb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 13:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752167AbYJUROF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 13:14:05 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:17717 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbYJUROE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 13:14:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=TeMk833z9ZSO9dnd9HBYDAU7KXq20WEnccZL0xRF2SMEt0du0UAaxHlKHQmOCLeCfh
         JRZs/wMyyHVKV/AW8mX0dLOtccWU8AE1yDdhj+5MLx7BDnq1yCsBnHiEltfmwQWsolAM
         g67Ac3gKRA0nQcmZB2j6xEfjiHuPui4ZwgVL8=
Message-ID: <ba7d8f720810211014g472c3e83oba511c24e1c2eb97@mail.gmail.com>
Date: Tue, 21 Oct 2008 13:14:02 -0400
From: "Dan Upton" <upton.dan.linux@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: debugging an oops that kills the system
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'm hoping for some pointers on debugging an oops that ultimately
hangs the system.  I'm doing some scheduler work and I can fairly
reliably duplicate the error on my machine, but the output is too
large for one screen and the system becomes unresponsive after the
crash so I can't scroll the console.  I tried purchasing a  USB->DB9
cable to log to a remote terminal, but so far I haven't had any luck
getting that to work.  Using kdump/kexec doesn't work either--I got
the second kernel to boot successfully using the magic sysrq example
in the documentation, but the second kernel doesn't boot with my
actual crash.  Any other suggestions for what I might do?

Thanks,
-dan
