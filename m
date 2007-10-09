Return-Path: <linux-kernel-owner+w=401wt.eu-S1754670AbXJIDeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbXJIDeS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 23:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752827AbXJIDeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 23:34:09 -0400
Received: from smtp115.sbc.mail.re3.yahoo.com ([66.196.96.88]:34817 "HELO
	smtp115.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752773AbXJIDeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 23:34:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=YPeiPvcJYFgPBRcG7R/wTTKnLqxYAiyqz3EMNezj0Imlb+s8Gteq7WzcVnRptcLYM9xQ5lBgn0qK3VYcaQwMhmWCYi9RnHxzkcgxQeUM1n9h88hqDP9j6HUwLtSU9UUkrmR823Jwrloh00kn4ehsPkuKb8X9vGEIstRkqMXu9vw=  ;
X-YMail-OSG: 5V2EYCgVM1mJZeAJEMJjmM8E.ro5IXs9ebK7JYKLGcV4Hg_EyCaHuecQJygdYF6QEz01j5POC9cESyhOBthSfBF7N2gRoe58QMyhETJ1pglYMr3KhOItWhZ7rIKF55kltVD.vOvgAFQJSA--
Date: Mon, 08 Oct 2007 20:34:12 -0700
From: David Brownell <david-b@pacbell.net>
To: greg@kroah.com, davem@davemloft.net
Subject: Re: OHCI root_port_reset() deadly loop...
Cc: linux-usb-users@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <20071007.005156.85395415.davem@davemloft.net>
 <20071008.165420.42793456.davem@davemloft.net>
 <20071009031049.GD14127@kroah.com>
 <20071008.201653.43030513.davem@davemloft.net>
In-Reply-To: <20071008.201653.43030513.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071009033412.E37E323700C@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> However, when both OHCI and EHCI are built as modules (or, similarly
> I guess, OHCI is built-in and EHCI is modular) there appears to be
> nothing in userspace which makes sure EHCI gets loaded first.

The old /etc/hotplug/usb.rc script made sure to load those modules
in the correct order:  EHCI first.

