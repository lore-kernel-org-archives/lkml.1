Return-Path: <linux-kernel-owner+w=401wt.eu-S1754635AbYIQNU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635AbYIQNU3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 09:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752714AbYIQNUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 09:20:08 -0400
Received: from web15006.mail.cnb.yahoo.com ([202.165.103.63]:23529 "HELO
	web15006.mail.cnb.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752736AbYIQNUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 09:20:07 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Sep 2008 09:20:06 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.cn;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=qJe1G/FmYmsHENW/joVW3fzIE1H2r2tusYFJdiok95EgOjSz9WwsLdouFI5cPyMQRp/xDF/Lq2GNe4mgL60rpakv8BQ8xUOLzv5nvMOF1vTa9VsZr6D67dNGsj6abrdjxCvEyYRrfgVZftdKf2WbqbLDR/BgNSMaNMGo8pAdxWM=;
X-YMail-OSG: 8n6m0ekVM1nzHRGWzTMUuPMbaZkE4D7KvU97VySHbVmVJ3t.icLpKCrgRz_GChaFKg--
Date: Wed, 17 Sep 2008 21:13:25 +0800 (CST)
From: zheng yong <zy_ball@yahoo.com.cn>
Subject: 2.6.26:in NF_BR_FORWARD hook why packet dissapeared? 
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: 8bit
Message-ID: <898750.95293.qm@web15006.mail.cnb.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

in NF_BR_FORWARD hook function, 
I get a sk_buff * parameter called skb.
I use the skb and skb_copy_expand to create a new
sk_buff * called new_skb, 
the new_skb has the same ip header and tcp header with
skb, except recompute ip/tcp checksum,
then send it out using dev_queue_xmit, 
dev_queue_xmit returnes successful(returnes 0), 
and in NF_BR_FORWARD hook function I return NF_DROP.
but at the peer, can not receive the packet sent.
I use ethereal, sometimes, I will receive some
"Ethernet II" packets, but their ethernet addresses
are wrong, It seems they were filled using the first
12 bytes of ip header.
why?


      ___________________________________________________________ 
 —≈ª¢” œ‰£¨ƒ˙µƒ÷’…˙” œ‰£° 
http://cn.mail.yahoo.com/
