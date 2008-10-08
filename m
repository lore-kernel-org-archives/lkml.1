Return-Path: <linux-kernel-owner+w=401wt.eu-S1755318AbYJHKlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318AbYJHKlu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 06:41:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753795AbYJHKlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 06:41:42 -0400
Received: from web30101.mail.mud.yahoo.com ([209.191.69.33]:35574 "HELO
	web30101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753783AbYJHKlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 06:41:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=nd/xUCsH7ykirdDUzo3WGfu6sf4+pCMJ5g9RTB684K7TUCqUb5ivLNceSQB8qxW8FZfoZdtZFCrBzJh/Jbj4Quay8+8hCgfCkZFYDdwWtbDXqxJwdpHBMLw56PRnhRAgHShn+Weowtw2y0kArBMHvhuBG/QxTR8uk++GV1qnNjw=;
X-YMail-OSG: pA7uBMEVM1nLUBUCbCGIUTedVc2_j4mmxsuqDESSC1u420kZtYVjEPkf4oAvSkkq0iC.2xQPV8J7rV5_kj44mpp.xdLskrfDX4Msc_6BhoeoJ0ijRxZ3.if3WLkYLZm8XTYxH5PmMucw.sebbix7IhUvjaxFc_i7CDNdLsUV
X-Mailer: YahooMailWebService/0.7.247.3
Date: Wed, 8 Oct 2008 03:41:41 -0700 (PDT)
From: Parav Pandit <paravpandit@yahoo.com>
Reply-To: paravpandit@yahoo.com
Subject: sending TCP/IP packet based on NIC MTU size
To: Linux kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <513565.4838.qm@web30101.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am searching Linux kernel TCP/IP code which does following functionality.

TCP/IP stack needs to check that - 
how many bytes of a TCP stream it can send to NIC driver.

Can anybody point me where this check in performed?
Like if MTU size is set to 1500 for a NIC and VLAN is not set then it will send 1492 bytes. 
If VLAN is set then it will send 1398 bytes to NIC.

Regards,
Parav Pandit



      
