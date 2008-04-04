Return-Path: <linux-kernel-owner+w=401wt.eu-S1758174AbYDDRbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758174AbYDDRbc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 13:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756422AbYDDRbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 13:31:25 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:18344 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013AbYDDRbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 13:31:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=vhgnXsngugpZxEoQ2eOuHXf0oqnQCGqh+tNzRvyJY6r5tk/FSai4F/aH/iajrr6gEf9cLffWfHVJtZRrHhOCCtFEpbT1bPcle2PcXUF6unKMV7WCg7jCRn9gc4ZDYU1G2GtLwZnXxeJmeJ6dobH2sSqu3VRLIqn92LvI7IL5jbk=
Message-ID: <47F665E6.2010409@googlemail.com>
Date: Fri, 04 Apr 2008 19:31:18 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Gabriel C <crazy@frugalware.org>, netdev <netdev@vger.kernel.org>,
       linux-usb@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: array subscript is above array bounds warnings with gcc4.3
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I noticed these warning on my randconfig logs of some builds :

..

drivers/usb/core/hcd.c: In function 'usb_hcd_poll_rh_status':                                                                                                
include/asm/string_32.h:65: warning: array subscript is above array bounds

net/netfilter/nf_conntrack_proto_sctp.c: In function 'sctp_packet':                                                                                          
net/netfilter/nf_conntrack_proto_sctp.c:374: warning: array subscript is above array bounds

drivers/acpi/tables/tbfadt.c: In function 'acpi_tb_create_local_fadt':                                                                                       
include/asm/string_32.h:65: warning: array subscript is above array bounds

...

Regards,

Gabriel
