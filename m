Return-Path: <linux-kernel-owner+w=401wt.eu-S1760115AbXFGMuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760115AbXFGMuU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 08:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756504AbXFGMuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 08:50:10 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:43479 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755608AbXFGMuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 08:50:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=FiVw3aWQF87ohDssWs57uoeqEpq0KP9jaT1D6bZewCQw7wfMmB82C3Cv3zUzM9MnOyRMtSXjS2Gq+DIA4CP2EYTaoxrWZz3PrsYFzPb/ASTuhQnLm62BF7urNy3kM9x90ieTPJieSFXxXOBjOxfZGeKcvLAuxBrEXXMZjX4aksM=
Message-ID: <f69849430706070550k4780060dheaa0f3073555d137@mail.gmail.com>
Date: Thu, 7 Jun 2007 05:50:06 -0700
From: "kernel coder" <lhrkernelcoder@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: tcp/ip stack question
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
       I am recieveing the packet on eth1 and want to send it through eth2.

I've written code in netif_recieve_skb function .This code changes the
mac header in sk_buff structure so that it can be send through other
interface card.But when i call ip_dev_find fucntion to get the second
interface structure ,NULL is returned.I checked the ip of second
ethernet card  and it was similar to one passed to ip_dev_find
fucntion,then why NULL is being returned?


Actually if i get the correct dev structure from ip_dev_find fucntion
then i'll assign that dev structure to current skbuff->dev  and call
dev_queue_xmit fucntion,so that it transmitted through second
interface card.Is mine approach correct?


shahzad
