Return-Path: <linux-kernel-owner+w=401wt.eu-S1753437AbXHRGfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbXHRGfc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 02:35:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751527AbXHRGfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 02:35:22 -0400
Received: from web36507.mail.mud.yahoo.com ([209.191.85.7]:46918 "HELO
	web36507.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751294AbXHRGfW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 02:35:22 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Sat, 18 Aug 2007 02:35:21 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=PIeUWjykCE0rQTdcUVM3/t0I1Kn3CVGyVZzqKadXzfE0wyUxa4LmcpXCNKE9KiXhhesKINB98exoSjfW1qLIMqduy4dO1ZYbSp6HKAJJbo7rNdh+ZoA1rM1K7b4qZesnRZbSh/uKMEOYZRGox4ao7gOiwUR4jvj9CaS2ojh7iHM=;
X-YMail-OSG: wW7AoQEVM1lp7DZOocUK8S7ITMVY2KVzaFDxSXBu4gStd8T9XjwqujaisgKVqciWRmFrYyf8rw--
X-Mailer: YahooMailRC/651.48 YahooMailWebService/0.7.119
Date: Fri, 17 Aug 2007 23:28:40 -0700 (PDT)
From: sean a <seansd@yahoo.com>
Subject: Re: [PATCH] [5/12] x86_64: Make patching more robust, fix paravirt
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Message-ID: <63986.35847.qm@web36507.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

git-bisect bad ab144f5ec64c42218a555ec1dbde6b60cf2982d6

Also breaks booting in VMWare's WS 6 if paravirtual support is enabled for the guest.
Hope this helps narrow it down.

Sean
