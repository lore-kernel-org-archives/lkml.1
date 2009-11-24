Return-Path: <linux-kernel-owner+w=401wt.eu-S934182AbZKXW1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934182AbZKXW1O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 17:27:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933460AbZKXW1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 17:27:14 -0500
Received: from ns.firmix.at ([62.141.48.66]:6075 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932789AbZKXW1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 17:27:13 -0500
Subject: Re: cannot compile linux-2.6-tip tree
From: Bernd Petrovitsch <bernd@firmix.at>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, rostedt@goodmis.org, fweisbec@gmail.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20091124172208.GG1975@jolsa.lab.eng.brq.redhat.com>
References: <20091124124107.GA1975@jolsa.lab.eng.brq.redhat.com>
	 <20091124154511.GG21821@elte.hu>
	 <20091124172208.GG1975@jolsa.lab.eng.brq.redhat.com>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Tue, 24 Nov 2009 23:27:12 +0100
Message-Id: <1259101632.6188.6.camel@gimli.petrovitsch.priv.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.67 on ns.firmix.at
X-Firmix-Spam-Score: -2.286 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-2.286 required=5
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
X-Firmix-Received-Date: Tue, 24 Nov 2009 23:27:19 CET
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Die, 2009-11-24 at 18:22 +0100, Jiri Olsa wrote: 
> On Tue, Nov 24, 2009 at 04:45:11PM +0100, Ingo Molnar wrote:
[...] 
> > It's rare but happens. 'make clean' will cure that.
Apart from disk full, hitting quota limits may give similar errors.

[...] 
> I tried make clean and it did not help..

- Did you change the architecture without `make mrproper` in between?
  Yes, `make clean` should cure that but ....
- Did some cross-gcc, cross-objdump, ... get in the PATH?

Save .config, `make mrproper`, put .config back, `make` and see it it
persists.

Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services

