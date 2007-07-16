Return-Path: <linux-kernel-owner+w=401wt.eu-S1762070AbXGPVM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762070AbXGPVM6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 17:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760068AbXGPVMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 17:12:40 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:46577 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759898AbXGPVMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 17:12:39 -0400
In-Reply-To: <adaabtww8qi.fsf@cisco.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Christoph Raisch <raisch@de.ibm.com>,
       "OF-General" <general@lists.openfabrics.org>,
       Hoang-Nam Nguyen <hnguyen@de.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       Roland Dreier <rolandd@cisco.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
MIME-Version: 1.0
Subject: Re: [PATCH 10/10] IB/ehca: Support large page MRs
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
From: Joachim Fenkes <FENKES@de.ibm.com>
Message-ID: <OFD7499E67.C6B5EA9B-ONC125731A.00715FED-C125731A.007484A7@de.ibm.com>
Date: Mon, 16 Jul 2007 23:11:47 +0200
X-MIMETrack: Serialize by Router on D12ML064/12/M/IBM(Release 7.0.2HF71 | November 3, 2006) at
 16/07/2007 23:12:12,
	Serialize complete at 16/07/2007 23:12:12
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier <rdreier@cisco.com> wrote on 16.07.2007 19:37:09:

>  > If enabled via the mr_largepage module parameter, 
> 
> Why the module parameter?  Is there any reason a user would want to
> turn this off?  Or conversely, why is it off by default?

We're pretty confident this new feature works, but as with all new and 
possibly experimental features, there are chances it might explode your 
machine when activated. So, like with the scaling code, we want the user 
to make the conscious decision of using this code instead of activating it 
by default.
 
>  >  static ssize_t ehca_show_nr_eqs(struct device *dev,
>  >              struct device_attribute *attr,
>  >              char *buf)
>  >  {
>  >     return sprintf(buf, "%d\n", ehca_nr_eqs);
>  >  }
>  > -
>  >  static DEVICE_ATTR(nr_eqs, S_IRUGO, ehca_show_nr_eqs, NULL);
> 
> Although trivial, this chunk doesn't really belong in this patch --
> just fix it up in the multiple EQ patch (which I haven't merged yet).

Sure thing.

Regards,
  Joachim
