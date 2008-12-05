Return-Path: <linux-kernel-owner+w=401wt.eu-S1756516AbYLESfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516AbYLESfY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 13:35:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751653AbYLESfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 13:35:09 -0500
Received: from web30107.mail.mud.yahoo.com ([209.191.69.39]:38658 "HELO
	web30107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750991AbYLESfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 13:35:08 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Dec 2008 13:35:07 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=ZRa2ut1GADCoq6l+R2zFHKMqjmqw4GEo5nXUWe3AKwHwZaCOa9UOQ2zrObdJ/zjCI9IBmMUXbPjTJ3xAXDvoi7EU+gUo1zR3ctbGT2XcxAcHcj2uah3vBaYY6xRaV2YLzyRHazNHNjs/ZmTrfCNLHAexkxvQp1hbuA8rUXlGTdU=;
X-YMail-OSG: nqqT9xwVM1mVzaWOAaAH_g0vU5QzuvGcmIfc30bITW3Dbt5IXGjosict.3jfaVavGuQFYVTCW1O7UWP.TQOsWvggaHbcsPlUuJC9IgIq6DukkfITvyPnHv8wbgolJooK0GBdbZJ.Q8zqA.FNt7Nsu5wQ_0dXdBXkrhUq4_w-
X-Mailer: YahooMailWebService/0.7.260.1
Date: Fri, 5 Dec 2008 10:28:27 -0800 (PST)
From: Parav Pandit <paravpandit@yahoo.com>
Reply-To: paravpandit@yahoo.com
Subject: mechanism to syncronise device access from user and kernel
To: Linux kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <377462.57009.qm@web30107.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a device whose registers are accessed by driver as well as user space application via mmap() area.

How to synchronize the access (avoid race condition) between user space driver and kernel mode driver, in single CPU and multi-CPU systems?

Regards,
Parav Pandit



      
