Return-Path: <linux-kernel-owner+w=401wt.eu-S933888AbZHEA27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933888AbZHEA27 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 20:28:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933867AbZHEA24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 20:28:56 -0400
Received: from n22.bullet.mail.mud.yahoo.com ([68.142.206.161]:29994 "HELO
	n22.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933338AbZHEA23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 20:28:29 -0400
X-Yahoo-Newman-Id: 549658.3388.bm@omp402.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=BCBrEjvZ2Em5k+b57WnWaDkiSYrgXwbrhUBIk1Cdz3z/7W2V0gF8pFw///f+413PIVqJGtrTS5GjkON6TViB0bmFwFv89RYSXLslUUIhEp9DAMQ4DL3lJvNLMROVeKQRMLek3O1vAHTeUIpfVuVy/FWMWzLWR5tZqFM0BnF66RI=  ;
X-YMail-OSG: Zf3JntAVM1l78pbPGhgJBfbGcnfwWvzGISjIzBhNTtsjmiVdWz8gsczUpqcfjtdK0BfaRJDfdsmxueI8DeMIexOYIodK3rFl1uEpfnZYUrd8ZDlVoAtv3uGZMWL4NnC96PdWlTRieGfugSdWmrKp8eJhqlEP7kvxXmATGGDgNRdqoW8BfcDocQ6Hvuec.8Ouq5wKKbxYcP.SuweCVJY1mUfnFT2NgtdvEOPRWX6yxON4TZcDgQ2K8uJIJPKgOwHG0dM7ZKDrc0ZosMo-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: avorontsov@ru.mvista.com
Subject: Re: [PATCH 0/7] Device table matching for SPI subsystem
Date: Mon, 3 Aug 2009 19:16:02 -0700
User-Agent: KMail/1.9.10
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       David Woodhouse <dwmw2@infradead.org>,
       Grant Likely <grant.likely@secretlab.ca>,
       Jean Delvare <khali@linux-fr.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       linuxppc-dev@ozlabs.org
References: <20090729170345.GA26787@oksana.dev.rtsoft.ru>
In-Reply-To: <20090729170345.GA26787@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908031916.02880.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 July 2009, Anton Vorontsov wrote:
> 	platform_data is overkill for m25p80 chips, the
> driver only needs to know exact chip model, and that's what device
> tables are for.

To be fair, the platform_data also supports partitioning
and labeling e.g. for cmdlinepart ... though I'd tend to
agree that most SPI flash chips are kind of small (so
they're mostly just one smallish partition).



