Return-Path: <linux-kernel-owner+w=401wt.eu-S1752951AbXBJD1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951AbXBJD1Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 22:27:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752953AbXBJD1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 22:27:25 -0500
Received: from gateway.insightbb.com ([74.128.0.19]:47749 "EHLO
	asav00.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950AbXBJD1Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 22:27:24 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aj0KAJTKzEVKhRO4UGdsb2JhbACHIYcpAQEqkWwBAQE
From: Dmitry Torokhov <dtor@insightbb.com>
To: nigel@nigel.suspend2.net
Subject: Re: NAK new drivers without proper power management?
Date: Fri, 9 Feb 2007 22:27:21 -0500
User-Agent: KMail/1.9.3
Cc: Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>
References: <fa.xSKPgY66Q+DPCZ1pszFFfdrJ0To@ifi.uio.no> <45CD24F6.8090107@shaw.ca> <1171073149.3863.4.camel@nigel.suspend2.net>
In-Reply-To: <1171073149.3863.4.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200702092227.22283.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nigel,

On Friday 09 February 2007 21:05, Nigel Cunningham wrote:
> [   17.684475] Device driver serio0 lacks bus and class support for being resumed.
> [   17.684724] Device driver serio1 lacks bus and class support for being resumed.
> [   17.684874] Device driver psaux lacks bus and class support for being suspended or resumed.
> [   17.685015] Device driver serio2 lacks bus and class support for being resumed.
> [   18.373576] Device driver serio3 lacks bus and class support for being resumed.
> [   18.375666] Device driver serio4 lacks bus and class support for being resumed.
> 

You should probably only warn if driver does not have resume method - not
having suspend is quite valid if driver is able to restore state at resume
without explicitely saving anything at suspend time.

-- 
Dmitry
