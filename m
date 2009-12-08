Return-Path: <linux-kernel-owner+w=401wt.eu-S965281AbZLHAoD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965281AbZLHAoD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 19:44:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965258AbZLHAoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 19:44:03 -0500
Received: from web50102.mail.re2.yahoo.com ([206.190.38.30]:24447 "HELO
	web50102.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965254AbZLHAoC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 19:44:02 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=NgptqFcponGkNYPmwfJCTHS7z/A7/4iDzc+sCv4zVGmV2DIrBrfk214LfAxyQ/jXhWhI0v7ACSS9GD+Qq9QNeTBNlUtp2ubDZYeQ9Pg941xpoVcHqlLnWvr5auYs9mHehJxnHemzvwGrJzml3mOIaf/y/2Nc2OQ0NSXHe7GvUGE=;
Message-ID: <979363.29471.qm@web50102.mail.re2.yahoo.com>
X-YMail-OSG: SD_o7ZIVM1kc918lKhYZo4oiqzGAgpzMNKXhpUSebwHtSlUzsXPE6GRiDmj8RHrBLIBpj6.k1KRLdcWPNOtSqL97MGF54C.c9bbAhcB_A1ed0EdpbyXCSQ6oaIsu62t4ljsazKUkenNdMWfCoSV859sHwoyMolBSXItd7lezZ2DixCDKOWcD.PsNrB4D58Sg1ZJaGLaAqtATNnwncaqxu4yE0Nthpsjlg8g38h8LP1NmH1K4N5CMtCP8XucCQAX8HTh9aBwMTXMHiPiZZpqM95DmjpTgobmJC96Q5EMIyNtbkysrdxcz2JaBIoOdmXnNVuJgYpNNdeauI5I0QWAWQLglSUCmgyMe.PRugapah4ZIhImKQhyS3got1sywgSvRb9M-
X-Mailer: YahooMailClassic/9.0.19 YahooMailWebService/0.8.100.260964
Date: Mon, 7 Dec 2009 16:44:06 -0800 (PST)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: [PATCH 1/2] EDAC: add __init to i7core_xeon_pci_fixup
To: Jiri Slaby <jslaby@suse.cz>, Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@redhat.com>
In-Reply-To: <20091204155428.307e612d@jbarnes-piketon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Fri, 12/4/09, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> From: Jesse Barnes <jbarnes@virtuousgeek.org>
> Subject: Re: [PATCH 1/2] EDAC: add __init to i7core_xeon_pci_fixup
> To: "Jiri Slaby" <jslaby@suse.cz>
> Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org, "Mauro Carvalho Chehab" <mchehab@redhat.com>
> Date: Friday, December 4, 2009, 4:54 PM
> On Mon, 30 Nov 2009 21:19:41 +0100
> Jiri Slaby <jslaby@suse.cz>
> wrote:
> 
> > It's called only from an __init function and is the
> only user
> > of pcibios_scan_specific_bus which will be marked as
> __devinit in
> > the next patch.
> > 
> > Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> > Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> > ---
> >  drivers/edac/i7core_edac.c |    2 +-
> >  1 files changed, 1 insertions(+), 1
> deletions(-)
> > 
> > diff --git a/drivers/edac/i7core_edac.c
> b/drivers/edac/i7core_edac.c
> > index 4de5a18..c7fc0d5 100644
> > --- a/drivers/edac/i7core_edac.c
> > +++ b/drivers/edac/i7core_edac.c
> > @@ -1141,7 +1141,7 @@ static void
> i7core_put_all_devices(void)
> >         
> i7core_put_devices(i7core_dev);
> >  }
> >  
> > -static void i7core_xeon_pci_fixup(int dev_id)
> > +static void __init i7core_xeon_pci_fixup(int dev_id)
> >  {
> >      struct pci_dev *pdev = NULL;
> >      int i;
> 
> I don't know who handles EDAC patches, but I'm pretty sure
> it's not
> me. :)  

Maruo has the i7core tree that he is building on for i7 stuff
boris from AMD has the amd64 tree
I handle the others and send to Andrew Morton

doug thompson


> It doesn't apply to my tree anyway, so it
> probably needs a
> refresh.
> 
> Thanks,
> -- 
> Jesse Barnes, Intel Open Source Technology Center
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
