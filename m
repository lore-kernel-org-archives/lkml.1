Return-Path: <linux-kernel-owner+w=401wt.eu-S964995AbZGQRo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964995AbZGQRo5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 13:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964965AbZGQRo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 13:44:56 -0400
Received: from outbound-mail-311.bluehost.com ([67.222.54.4]:34286 "HELO
	outbound-mail-311.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S964918AbZGQRoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 13:44:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Subject:Message-ID:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=cJrUq0kz8I5489GH0Jrs0bcdGEpGU/JlYAvxxx+o/prSjLmo2yG94znfEsN+ko4FX7zfYiAFm6hSXMkUYYo4DqpF1H89qv1M8jnxJR2m8uU/xBkemKhwEL+AJrSTIUE1;
Date: Fri, 17 Jul 2009 10:44:48 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [git pull] PCI fix
Message-ID: <20090717104448.1cd0d7c0@jbarnes-g45>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just one small fix from Yinghai in this pull.  I expect a couple of
more from Alex in the next one, but I'd like to get them through
linux-next first.

The following changes since commit c2cc49a2f8a479dde96a599646d30b6cc9dbed78:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../sfrench/cifs-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 for-linus

Yinghai Lu (1):
      x86/pci: insert ioapic resource before assigning unassigned resources

 arch/x86/include/asm/io_apic.h |    2 ++
 arch/x86/kernel/apic/io_apic.c |   14 +++-----------
 arch/x86/pci/i386.c            |    7 +++++++
 3 files changed, 12 insertions(+), 11 deletions(-)


-- 
Jesse Barnes, Intel Open Source Technology Center
