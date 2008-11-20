Return-Path: <linux-kernel-owner+w=401wt.eu-S1756773AbYKTUur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773AbYKTUur (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 15:50:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754749AbYKTUui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 15:50:38 -0500
Received: from blaine.gmane.org ([80.91.229.8]:54031 "EHLO hugh.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752727AbYKTUuh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 15:50:37 -0500
Date: Thu, 20 Nov 2008 21:17:59 +0200
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>
To: public-mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@hugh.gmane.org
Cc: Evgeniy Polyakov 
	<public-zbr-i6C2adt8DTjR7s880joybQ@hugh.gmane.org>,
       Christoph Hellwig <public-hch-jcswGhMUV9g@hugh.gmane.org>,
       Robert Love <public-rlove-L7G0xEPcOZbYtjvyW6yDsg@hugh.gmane.org>,
       public-linux-api-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org,
       public-linux-kernel-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org,
       Andrew Morton 
	<public-akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@hugh.gmane.org>,
       public-john-jueV0HHMeujJJrXXpGQQMAC/G2K4zDHf@hugh.gmane.org
Subject: Re: [take 3] Use pid in inotify events.
Message-ID: <20081120191759.GH31176@sci.fi>
Mail-Followup-To: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>,
	mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	Evgeniy Polyakov <zbr-i6C2adt8DTjR7s880joybQ@public.gmane.org>,
	Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>,
	Robert Love <rlove-L7G0xEPcOZbYtjvyW6yDsg@public.gmane.org>,
	linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
	john-jueV0HHMeujJJrXXpGQQMAC/G2K4zDHf@public.gmane.org
References: <acdcfe7e0811081035l56eedf05x8b3b7ee2fc01eee6@mail.gmail.com> <20081116232450.GA13547@ioremap.net> <cfd18e0f0811170859w1d3f903ej1d5626f2d2bf4496@mail.gmail.com> <20081118131937.GC16944@lst.de> <20081119140500.GA25968@ioremap.net> <cfd18e0f0811190634g276b4a2dm5b3d5de25a5c9222@mail.gmail.com> <cfd18e0f0811190643j7769f768q53889bbc950ef251@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <cfd18e0f0811190643j7769f768q53889bbc950ef251@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Content-Transfer-Encoding: 8BIT
X-TMDA-Confirmed: Thu, 20 Nov 2008 21:50:27 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On Wed, Nov 19, 2008 at 09:43:41AM -0500, Michael Kerrisk wrote:
> I think what is really needed at this point is some consideration of
> what other extensions (if any) might be desired for inotify, and how
> we might be best create a design that suits those and future needs.

In case people are taking notes for "inotify ng" I have one improvement
request. Add some way to know when a move event is complete. Currently if
you're just wathing the source or target directory of a move you only get
one of the MOVED_FROM/MOVED_TO events. Not knowing whether you'll
eventually receive the other half of the event is problematic when you
want to treat such unpaired events the same as DELETE/CREATE events.

-- 
Ville Syrjälä
syrjala@sci.fi
http://www.sci.fi/~syrjala/


