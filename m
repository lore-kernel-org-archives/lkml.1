Return-Path: <linux-kernel-owner+w=401wt.eu-S965743AbXDBTdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965743AbXDBTdO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 15:33:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965745AbXDBTdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 15:33:14 -0400
Received: from web31801.mail.mud.yahoo.com ([68.142.207.64]:22036 "HELO
	web31801.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965743AbXDBTdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 15:33:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=3ne2hlVb/6uUR8XJn4b3klW5UXgWpjFRAT2XXJW5UFJCcN9MAGlUKDMxlTlqBu6/n8GissFxIiN1yRFeHmmpffPel/xw/6ZvNDDxIX8ptAzXxXB8SXk5ldwYM2Nch1qRSiEMKOEw6KKgD4suE1bz/giYT3YbhX+HXECeO+rkO/o=;
X-YMail-OSG: pq8XWVAVM1mOePbiWfohfwXkxxuIGsBxgufv1Gw.K7.R0IeUiE8PNc028UhHN0_VsOOCog--
Date: Mon, 2 Apr 2007 12:33:11 -0700 (PDT)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: Re: [RFD driver-core] Lifetime problems of the current driver model
To: James Bottomley <James.Bottomley@SteelEye.com>,
       Tejun Heo <htejun@gmail.com>
Cc: gregkh@suse.de, hugh@veritas.com, cornelia.huck@de.ibm.com,
       dmitry.torokhov@gmail.com, oneukum@suse.de, maneesh@in.ibm.com,
       rpurdie@rpsys.net, Jeff Garzik <jgarzik@pobox.com>,
       lkml <linux-kernel@vger.kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       SCSI Mailing List <linux-scsi@vger.kernel.org>
In-Reply-To: <1175278774.3760.44.camel@mulgrave.il.steeleye.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <824244.95510.qm@web31801.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- James Bottomley <James.Bottomley@SteelEye.com> wrote:

> I'd favour trying to separate kobject and struct device for this ...
> move all the sysfs stuff into kobject and device only stuff into struct
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Currently the kobject implementation is pure and well-defined.  It is
a good implementation [kobject], and I'd hate to see it lost into being
convoluted with/into another model.

Currently the infrastructure layers are well defined:
   kobject ->  (A layer with objects, their behavor and implementation)
          device ->   (--"--)
                  sysfs.   (--"--)
This isn't that bad of an infrastructure.

It is this well defined layering, i.e. objects, their behavior and
implementation, that allows different (better/worse) infrastructures
to be built on top of it.

It is this well-defined layering which will allow what Tejun wants
to be implemented.

> device ... but that would get us into disentangling the ksets, which, on
> balance, isn't going to be fun ...

     Luben

