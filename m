Return-Path: <linux-kernel-owner+w=401wt.eu-S1757483AbYEPPyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483AbYEPPyz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 11:54:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751056AbYEPPyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 11:54:44 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:48281 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753667AbYEPPyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 11:54:43 -0400
Message-Id: <1210953281.30902.1253547403@webmail.messagingengine.com>
X-Sasl-Enc: gLy9XRCX2zkwTmthrFjN1egIrhu7QLpQh2juOoFthUQN 1210953281
From: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
To: "Jan Lieskovsky" <jlieskov@redhat.com>,
       "Cyrill Gorcunov" <gorcunov@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Len Brown" <len.brown@intel.com>
Cc: linux-kernel@vger.kernel.org
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <1210930449.3812.15.camel@dhcp-lab-164.englab.brq.redhat.com>
Subject: Re: thinkpad_acpi: fix possible NULL pointer dereference if kstrdup    
   for ec_version_str failed
In-Reply-To: <1210930449.3812.15.camel@dhcp-lab-164.englab.brq.redhat.com>
Date: Fri, 16 May 2008 12:54:41 -0300
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 16 May 2008 11:34:09 +0200, "Jan Lieskovsky" <jlieskov@redhat.com> said:
> There is a potential NULL pointer dereference in
> thinkpad_acpi_module_exit() -- in case,
> kstrdup for thinkpad_id.ec_version_str failed.

One can kfree(NULL) without problems.  Is there any other unprotected access to ec_version_str that I failed to see?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

