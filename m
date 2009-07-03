Return-Path: <linux-kernel-owner+w=401wt.eu-S1755899AbZGCDvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899AbZGCDvR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 23:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753344AbZGCDvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 23:51:07 -0400
Received: from elasmtp-scoter.atl.sa.earthlink.net ([209.86.89.67]:53863 "EHLO
	elasmtp-scoter.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752783AbZGCDvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 23:51:06 -0400
X-Greylist: delayed 460 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Jul 2009 23:51:06 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=hkHEpAbNw6ZFJZdhy4QzOS9slJo2hvqZeJe3xGTnvYSN5b999fVR+SH95k72LzDk;
  h=Received:Message-Id:From:To:Content-Type:Content-Transfer-Encoding:Mime-Version:Subject:Date:X-Mailer:X-ELNK-Trace:X-Originating-IP;
Message-Id: <61448F53-1F7A-47EF-AAF3-CB2A46AB8009@earthlink.net>
From: Mitchell Erblich <erblichs@earthlink.net>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re : .... get_page_from_freelist : MInority Suggestion to accept GFP_NOFAIL accept during boot
Date: Thu, 2 Jul 2009 20:43:26 -0700
X-Mailer: Apple Mail (2.930.3)
X-ELNK-Trace: 074f60c55517ea841aa676d7e74259b7b3291a7d08dfec79ee76e1c0db5c159e48b67f07d3ca2030350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 98.234.127.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Group,


	If I may suggest a minority opinion about the depreciating of the  
GFP_NOFAIL flag..

	I saw no discussion on the acceptance of using this flag during boot  
and shortly
	after boot.

	Many kernel structures require memory and thus should guarantee memory
	before they continue.
	
	As Linux is moved within embedded environments with smaller amounts of
	physical memory, the chance that earlier mem failures becomes higher.

	For this logic alone, my minority opinion is to not depreciate the  
GFP_NOFAIL flag.

	Mitchell Erblich
	

	
	
	

	
