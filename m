Return-Path: <linux-kernel-owner+w=401wt.eu-S1756728AbZBFAP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728AbZBFAP7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 19:15:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753315AbZBFAPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 19:15:50 -0500
Received: from web33402.mail.mud.yahoo.com ([68.142.206.134]:23633 "HELO
	web33402.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753977AbZBFAPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 19:15:50 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=WYOAHhZIO1YIBTVwAvOt2hA58ZUqe5QhxscPW7fR5UY+8ef6IGN4z3gCTnsOcWMMJlrVGIPNo+1gtdnlRX9I4qCX3X3pZvD3c9hpG6ZSl6QOwAwPlPj719WUh5MfHoat5KDvhugMva9rRNuwgsrgMe4erUR/LEGudfxCYNAGds4=;
X-YMail-OSG: D2mEbaMVM1l7hY8O7LCMK7DnZCZfBhG6rRCRULY.rqOfk9Xp6mRvUxpluYoAqU0ODyRElJRQ5W317PButyQPBf.smE_hX96aYiNy6qUSjrSvXn4cYfrIj.VIwq6_zHOGPAhGkU0nggmWrOoknatSkrNxuVRKYyHtAgQb7f19OIa6VRmO1PYeIuJ9du_c
X-Mailer: YahooMailWebService/0.7.260.1
Date: Thu, 5 Feb 2009 16:15:48 -0800 (PST)
From: Vira <sri1369_s@yahoo.com>
Subject: Mapping non-page aligned data to user
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <305692.9769.qm@web33402.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

Is there a way to map a non-page aligned kernel physical address to user virtual address? remap_pfn_range and vm_insert_page operate only on page-aligned physical addresses.

If there is no such support, would it be too complicated to try out
writing something on my own to map non-page aligned addresses (the data
size is under my control - so I can make that a multiple of page size)?

Any suggestions appreciated.

Thanks
-- Vira


      
