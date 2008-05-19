Return-Path: <linux-kernel-owner+w=401wt.eu-S1761727AbYESRXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761727AbYESRXS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 13:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751211AbYESRXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 13:23:07 -0400
Received: from smtp101.rog.mail.re2.yahoo.com ([206.190.36.79]:27608 "HELO
	smtp101.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752322AbYESRXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 13:23:06 -0400
X-Greylist: delayed 403 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 May 2008 13:23:05 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=rogers.com;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:Organization:To:Subject:Date:User-Agent:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=bDOwbc3An2FwvzBTMlsYpbpw1UFuHzNl2E3v1B7BZInvjH/ZS3gS+6gA4FrUsxZotXvJ/r7kzKyV3GbvxRiu3ZLt9T39ulap9v4/s187//wwzyWHG3Za281OILKRl2UtAtqt9w/c+0hUHma6lvJb8CGuDMU5TMgxzCLpmvS1ths=  ;
X-YMail-OSG: 8qBYTboVM1nzZk_NoR__ITvMcvkuytt7pBwlvyjhvlLmaRnMtB3iJ85Xt4mULLPlrA--
X-Yahoo-Newman-Property: ymail-3
From: Shawn Starr <shawn.starr@rogers.com>
Organization: sh0n.net
To: linux-kernel@vger.kernel.org
Subject: Modern 2.6 kernels - Notification for changing hostname from proc/sys/kernel/hostname ?
Date: Mon, 19 May 2008 13:16:12 -0400
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200805191316.12424.shawn.starr@rogers.com>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, 

I was looking at utsname_sysctl.c (if this is the right place) and noticed 
there doesn't seem to be any notification via the connector bus to tell 
userspace the hostname has changed? Is this correct?

if so, would not not make sense to add such event triggers so that things like 
KDE would not have to poll to determine if the hostname changes and instead 
had D-BUS tell userspace the hostname changed?

Perhaps this could be applied to other values (where applicable) 
in /proc/sys/kernel?

Or is this all going to go into sysfs eventually (where some of this really 
might belong)

Thoughts?

Thanks, 
Shawn.
